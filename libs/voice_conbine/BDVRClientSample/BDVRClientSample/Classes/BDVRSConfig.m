//
//  BDVRSConfig.m
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25.
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import "BDVRSConfig.h"
#import "BDVoiceRecognitionClient.h"
#import "BDTheme.h"

// 类实现
@implementation BDVRSConfig
@synthesize resultContinuousShow;
@synthesize playStartMusicSwitch;
@synthesize playEndMusicSwitch;
@synthesize recognitionLanguage;
@synthesize voiceLevelMeter;
@synthesize uiHintMusicSwitch;
@synthesize isNeedNLU;
@synthesize libVersion = _libVersion;

#pragma mark - init & dealloc

- (id)init 
{
	self = [super init];
	if (self) 
	{
        resultContinuousShow = YES;
        playStartMusicSwitch = NO;
        playEndMusicSwitch = NO;
        _recognitionProperty = [[NSNumber numberWithInt: EVoiceRecognitionPropertyInput] retain];
        recognitionLanguage = EVoiceRecognitionLanguageChinese;
        voiceLevelMeter = NO;
        uiHintMusicSwitch = YES;
		isNeedNLU = NO;
        
		NSString *tmpString = [[BDVoiceRecognitionClient sharedInstance] libVer];
		_libVersion = [[NSString alloc] initWithString:tmpString];
        _theme = [[BDTheme lightBlueTheme] retain];
	}
	return self;
}

-(void)dealloc
{
	[_libVersion release];
    [_theme release];
    [super dealloc];
}

+ (BDVRSConfig *)sharedInstance
{
	static BDVRSConfig *_sharedInstance = nil;
	if (_sharedInstance == nil)
	{
		_sharedInstance = [[BDVRSConfig alloc] init];
	}
    
	return _sharedInstance;
}

- (NSString *)composeInputModeResult:(id)aObj
{
    NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
    for (NSArray *result in aObj)
    {
        NSDictionary *dic = [result objectAtIndex:0];
        NSString *candidateWord = [[dic allKeys] objectAtIndex:0];
        [tmpString appendString:candidateWord];
    }
    
    return [tmpString autorelease];
}


@end
