//
//  BDVRCustomRecognitonViewController.m
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import "BDVRCustomRecognitonViewController.h"
#import "BDVRClientUIManager.h"
#import "BDVRViewController.h"
#import "BDVRSConfig.h"
#import "BDVRSConfig.h"

#define VOICE_LEVEL_INTERVAL 0.1 // 音量监听频率为1秒中10次

// 私有方法分类
@interface BDVRCustomRecognitonViewController ()

- (void)createInitView; // 创建初始化界面，播放提示音时会用到
- (void)createRecordView;  // 创建录音界面
- (void)createRecognitionView; // 创建识别界面
- (void)createErrorViewWithErrorType:(int)aStatus; // 在识别view中显示详细错误信息
- (void)createRunLogWithStatus:(int)aStatus; // 在状态view中显示详细状态信息

- (void)finishRecord:(id)sender; // 用户点击完成动作
- (void)cancel:(id)sender; // 用户点击取消动作

- (void)startVoiceLevelMeterTimer;
- (void)freeVoiceLevelMeterTimerTimer;

@end// VoiceRecognitonViewController

// 类实现
@implementation BDVRCustomRecognitonViewController
@synthesize dialog = _dialog;
@synthesize clientSampleViewController;
@synthesize voiceLevelMeterTimer = _voiceLevelMeterTimer;

#pragma mark - init & dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
        // 
    }
    
    return self;
}

- (void)dealloc 
{
    [self freeVoiceLevelMeterTimerTimer];
	[_dialog release];
    [super dealloc];
}

#pragma mark - views lifestyle

- (void)loadView 
{
	UIView *tmpView = [[UIView alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRBackgroundFrame]];
    tmpView.backgroundColor = [UIColor clearColor];
	self.view = tmpView;
	[tmpView release];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // 开始语音识别功能，之前必须实现MVoiceRecognitionClientDelegate协议中的VoiceRecognitionClientWorkStatus:obj方法
    int startStatus = -1;
	startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
	if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
	{
		NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
		[self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];  // 延迟0.3秒，以便能在出错时正常删除view
        return;
	}
    
    // 是否需要播放开始说话提示音，如果是，则提示用户不要说话，在播放完成后再开始说话, 也就是收到EVoiceRecognitionClientWorkStatusStartWorkIng通知后再开始说话。
    if ([BDVRSConfig sharedInstance].playStartMusicSwitch)
    {
        [self createInitView];
    }
    else 
    {
        [self createRecordView];
    }
    
    self.view.alpha = 0.0f;
    
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning 
{
	[self cancel:nil];
	self.clientSampleViewController.logCatView.text = [self.clientSampleViewController.logCatView.text stringByAppendingFormat:@"\n内存警告，停止本次识别"]; // 发生内存警告时，停止语音识别，避免出现崩溃
    [super didReceiveMemoryWarning];
}

#pragma mark - button action methods

- (void)finishRecord:(id)sender 
{
    [[BDVoiceRecognitionClient sharedInstance] speakFinish];
}

- (void)cancel:(id)sender 
{
	[[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    
    if (self.view.superview)
    {
        [self.view removeFromSuperview];
    }
}

#pragma mark - MVoiceRecognitionClientDelegate

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    // 为了更加具体的显示错误信息，此处没有使用aStatus参数
    [self createErrorViewWithErrorType:aSubStatus];
}

- (void)VoiceRecognitionClientWorkStatus:(int)aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFlushData: // 连续上屏中间结果
        {
            NSString *text = [aObj objectAtIndex:0];
                        
            if ([text length] > 0)
            {
                [clientSampleViewController logOutToContinusManualResut:text];
            }

            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: // 识别正常完成并获得结果
        {
			[self createRunLogWithStatus:aStatus];
            
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
            {
                //  搜索模式下的结果为数组，示例为
                // ["公园", "公元"]
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                for (int i=0; i < [audioResultData count]; i++)
                {
                    [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
                }
                
                clientSampleViewController.resultView.text = nil;
                [clientSampleViewController logOutToManualResut:tmpString];
                [tmpString release];
            }
            else
            {
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                [clientSampleViewController logOutToContinusManualResut:tmpString];
            }
            
            if (self.view.superview)
            {
                [self.view removeFromSuperview];
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            // 此状态只有在输入模式下使用
            // 输入模式下的结果为带置信度的结果，示例如下：
            //  [
            //      [
            //         {
            //             "百度" = "0.6055192947387695";
            //         },
            //         {
            //             "摆渡" = "0.3625582158565521";
            //         },
            //      ]
            //      [
            //         {
            //             "一下" = "0.7665404081344604";
            //         }
            //      ],
            //   ]
            
            NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
            [clientSampleViewController logOutToContinusManualResut:tmpString];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: // 用户说话完成，等待服务器返回识别结果
        {
			[self createRunLogWithStatus:aStatus];
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
			
            [self createRecognitionView];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:
        {            
            if ([BDVRSConfig sharedInstance].voiceLevelMeter) 
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
			[self createRunLogWithStatus:aStatus];  
            
            if (self.view.superview) 
            {
                [self.view removeFromSuperview];
            }
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: // 识别库开始识别工作，用户可以说话
        {
            if ([BDVRSConfig sharedInstance].playStartMusicSwitch) // 如果播放了提示音，此时再给用户提示可以说话
            {
                [self createRecordView];
            }
            
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)  // 开启语音音量监听
            {
                [self startVoiceLevelMeterTimer];
            }
            
			[self createRunLogWithStatus:aStatus]; 

            break;
        }
		case EVoiceRecognitionClientWorkStatusNone:
		case EVoiceRecognitionClientWorkPlayStartTone:
		case EVoiceRecognitionClientWorkPlayStartToneFinish:
		case EVoiceRecognitionClientWorkStatusStart:
		case EVoiceRecognitionClientWorkPlayEndToneFinish:
		case EVoiceRecognitionClientWorkPlayEndTone:
		{
			[self createRunLogWithStatus:aStatus];
			break;
		}
        case EVoiceRecognitionClientWorkStatusNewRecordData:
        {
            break;
        }
        default:
        {
			[self createRunLogWithStatus:aStatus];
            if ([BDVRSConfig sharedInstance].voiceLevelMeter) 
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            if (self.view.superview) 
            {
                [self.view removeFromSuperview];
            }
 
            break;
        }
    }
}

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus) 
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {	
			[self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;   
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
			[self createRunLogWithStatus:aStatus];
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;   
        }          
    }
}

#pragma mark - voice search error result

- (void)firstStartError:(NSString *)statusString
{
    if (self.view.superview) 
    {
        [self.view removeFromSuperview];
    }
    
	[self createErrorViewWithErrorType:[statusString intValue]];
}

- (void)createErrorViewWithErrorType:(int)aStatus
{
    NSString *errorMsg = @"";
    
    switch (aStatus)
    {
        case EVoiceRecognitionClientErrorStatusIntrerruption:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonInterruptRecord", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusChangeNotAvailable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonChangeNotAvailable", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusUnKnow:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonStatusError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusNoSpeech:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoSpeech", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusShort:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoShort", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusException:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonException", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusTimeOut:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkTimeOut", nil); 
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusParseError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonParseError", nil);
            break;
        }
		case EVoiceRecognitionStartWorkNoAPIKEY:
		{
			errorMsg = NSLocalizedString(@"StringAudioSearchNoAPIKEY", nil);
            break;
		}
        case EVoiceRecognitionStartWorkGetAccessTokenFailed:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchGetTokenFailed", nil);
            break;
        }
		case EVoiceRecognitionStartWorkDelegateInvaild:
		{
			errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoDelegateMethods", nil);  
            break;
		}
		case EVoiceRecognitionStartWorkNetUnusable:
		{
			errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil); 
            break;
		}
		case EVoiceRecognitionStartWorkRecorderUnusable:
		{
			errorMsg = NSLocalizedString(@"StringVoiceRecognitonCantRecord", nil); 
            break;
		}
        case EVoiceRecognitionStartWorkNOMicrophonePermission:
		{
            errorMsg = NSLocalizedString(@"StringAudioSearchNOMicrophonePermission", nil); 
            break;
		}
        //服务器返回错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerNoFindResult:     //没有找到匹配结果
        case EVoiceRecognitionClientErrorNetWorkStatusServerSpeechQualityProblem:    //声音过小
            
        case EVoiceRecognitionClientErrorNetWorkStatusServerParamError:       //协议参数错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerRecognError:      //识别过程出错
        case EVoiceRecognitionClientErrorNetWorkStatusServerAppNameUnknownError: //appName验证错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerUnknownError:      //未知错误
        {
			errorMsg = [NSString stringWithFormat:@"%@-%d",NSLocalizedString(@"StringVoiceRecognitonServerError", nil),aStatus] ;
            break;
        }
        default:
        {
            errorMsg =[NSString stringWithFormat:@"%@：%d", NSLocalizedString(@"StringVoiceRecognitonDefaultError", nil), aStatus];
            break;
        }
    }
    
    [clientSampleViewController logOutToManualResut:errorMsg];
}

#pragma mark - voice search views

- (void)createInitView
{
    if (_dialog && _dialog.superview) 
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordBackground.png"]];
    tmpImageView.userInteractionEnabled = YES;
    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    self.dialog = tmpImageView;
    _dialog.backgroundColor = [UIColor clearColor];
    _dialog.center = self.view.center;
    [tmpImageView release];
    [self.view addSubview:_dialog];
    
    tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microphone.png"]];
    tmpImageView.center = [[BDVRClientUIManager sharedInstance] VRRecordBackgroundCenter];
    [_dialog addSubview:tmpImageView];
    [tmpImageView release];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecordTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    tmpLabel.textColor = [UIColor whiteColor];
    tmpLabel.text = NSLocalizedString(@"StringVoiceRecognitonInit", nil);
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRCenterButtonFrame];
    tmpButton.center = [[BDVRClientUIManager sharedInstance] VRCenterButtonCenter];
    tmpButton.backgroundColor = [UIColor clearColor];
    [tmpButton setTitle:NSLocalizedString(@"StringCancel", nil) forState:UIControlStateNormal];
    tmpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    tmpButton.titleLabel.textColor = [UIColor whiteColor];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
}

- (void)createRecordView
{
    if (_dialog && _dialog.superview) 
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordBackground.png"]];
    tmpImageView.userInteractionEnabled = YES;
    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    self.dialog = tmpImageView;
    _dialog.backgroundColor = [UIColor clearColor];
    _dialog.center = self.view.center;
    [tmpImageView release];
    [self.view addSubview:_dialog];
    
    tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microphone.png"]];
    tmpImageView.center = [[BDVRClientUIManager sharedInstance] VRRecordBackgroundCenter];
    [_dialog addSubview:tmpImageView];
    [tmpImageView release];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecordTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    tmpLabel.textColor = [UIColor whiteColor];
    tmpLabel.text = NSLocalizedString(@"StringVoiceRecognitonPleaseSpeak", nil);
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRLeftButtonFrame];
    tmpButton.backgroundColor = [UIColor clearColor];
    [tmpButton setTitle:NSLocalizedString(@"StringCancel", nil) forState:UIControlStateNormal];
    tmpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    tmpButton.titleLabel.textColor = [UIColor whiteColor];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
    
    tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRRightButtonFrame];
    [tmpButton setTitle:NSLocalizedString(@"StringVoiceRecognitonRecordFinish", nil) forState:UIControlStateNormal];
    tmpButton.titleLabel.textColor = [UIColor whiteColor];
    tmpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(finishRecord:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
    
}

- (void)createRecognitionView
{
    if (_dialog && _dialog.superview) 
        [_dialog removeFromSuperview];
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recognitionBackground.png"]];
    tmpImageView.userInteractionEnabled = YES;
    tmpImageView.alpha = 0.6; /* He Liqiang, TAG-130729 */
    self.dialog = tmpImageView;
    [tmpImageView release];
    _dialog.center = self.view.center;
    [self.view addSubview:_dialog];
    
    tmpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recognitionIcon.png"]];
	tmpImageView.center = [[BDVRClientUIManager sharedInstance] VRRecognizeBackgroundCenter];
	[_dialog addSubview:tmpImageView];
	[tmpImageView release];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:[[BDVRClientUIManager sharedInstance] VRRecognizeTintWordFrame]];
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    tmpLabel.textColor = [UIColor whiteColor];
    tmpLabel.text = NSLocalizedString(@"StringVoiceRecognitonIdentify", nil);
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.center = [[BDVRClientUIManager sharedInstance] VRTintWordCenter];
    [_dialog addSubview:tmpLabel];
    [tmpLabel release];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = [[BDVRClientUIManager sharedInstance] VRCenterButtonFrame];
    tmpButton.center = [[BDVRClientUIManager sharedInstance] VRCenterButtonCenter];
    tmpButton.backgroundColor = [UIColor clearColor];
    [tmpButton setTitle:NSLocalizedString(@"StringCancel", nil) forState:UIControlStateNormal];
    tmpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    tmpButton.titleLabel.textColor = [UIColor whiteColor];
    [_dialog addSubview:tmpButton];
    [tmpButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    tmpButton.showsTouchWhenHighlighted = YES;
    
}

#pragma mark - voice search log

- (void)createRunLogWithStatus:(int)aStatus
{	
    NSString *statusMsg = nil;
	switch (aStatus)
	{
		case EVoiceRecognitionClientWorkStatusNone: //空闲
		{
			statusMsg = NSLocalizedString(@"StringLogStatusNone", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayStartTone:  //播放开始提示音
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayStartTone", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayStartToneFinish: //播放开始提示音完成
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayStartToneFinish", nil);
			break;
		}
		case EVoiceRecognitionClientWorkStatusStartWorkIng: //识别工作开始，开始采集及处理数据
		{
			statusMsg = NSLocalizedString(@"StringLogStatusStartWorkIng", nil);
			break;
		}
		case EVoiceRecognitionClientWorkStatusStart: //检测到用户开始说话
		{
			statusMsg = NSLocalizedString(@"StringLogStatusStart", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayEndTone: //播放结束提示音 
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayEndTone", nil);
			break;
		}
		case EVoiceRecognitionClientWorkPlayEndToneFinish: //播放结束提示音完成
		{
			statusMsg = NSLocalizedString(@"StringLogStatusPlayEndToneFinish", nil);
			break;
		}
        case EVoiceRecognitionClientWorkStatusReceiveData: //语音识别功能完成，服务器返回正确结果
        {
			statusMsg = NSLocalizedString(@"StringLogStatusSentenceFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: //语音识别功能完成，服务器返回正确结果
        {
			statusMsg = NSLocalizedString(@"StringLogStatusFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: //本地声音采集结束结束，等待识别结果返回并结束录音
        {
			statusMsg = NSLocalizedString(@"StringLogStatusEnd", nil);
			break;
		}
		case EVoiceRecognitionClientNetWorkStatusStart: //网络开始工作
        {
			statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusStart", nil);
            break;   
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:  //网络工作完成
        {
			statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusEnd", nil);
            break;   
        } 
        case EVoiceRecognitionClientWorkStatusCancel:  // 用户取消
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusCancel", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: // 出现错误
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusErorr", nil);
            break;
        } 
		default:
		{
			statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusDefaultErorr", nil);
			break;
		}
	}
	
	if (statusMsg)
	{
		NSString *logString = self.clientSampleViewController.logCatView.text;
		if (logString && [logString isEqualToString:@""] == NO)
		{
			self.clientSampleViewController.logCatView.text = [logString stringByAppendingFormat:@"\r\n%@", statusMsg];
		}
		else 
		{
			self.clientSampleViewController.logCatView.text = statusMsg;
		}
	}
}

#pragma mark - VoiceLevelMeterTimer methods

- (void)startVoiceLevelMeterTimer
{
    [self freeVoiceLevelMeterTimerTimer];

    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSinceNow:VOICE_LEVEL_INTERVAL];
    NSTimer *tmpTimer = [[NSTimer alloc] initWithFireDate:tmpDate interval:VOICE_LEVEL_INTERVAL target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [tmpDate release];
    self.voiceLevelMeterTimer = tmpTimer;
    [tmpTimer release];
    [[NSRunLoop currentRunLoop] addTimer:_voiceLevelMeterTimer forMode:NSDefaultRunLoopMode];
}

- (void)freeVoiceLevelMeterTimerTimer
{
	if(_voiceLevelMeterTimer)
	{
		if([_voiceLevelMeterTimer isValid])
			[_voiceLevelMeterTimer invalidate];
		self.voiceLevelMeterTimer = nil;
	}
}

- (void)timerFired:(id)sender
{
    // 获取语音音量级别
    int voiceLevel = [[BDVoiceRecognitionClient sharedInstance] getCurrentDBLevelMeter];
    
    NSString *statusMsg = [NSLocalizedString(@"StringLogVoiceLevel", nil) stringByAppendingFormat:@": %d", voiceLevel];
    [clientSampleViewController logOutToLogView:statusMsg];
}

#pragma mark - animation finish

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    // 
}

@end // BDVRCustomRecognitonViewController
