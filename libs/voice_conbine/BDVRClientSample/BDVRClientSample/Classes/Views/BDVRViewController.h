//
//  BDVRViewController.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-24.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRFileRecognizer.h"
#import "BDVRDataUploader.h"

// 枚举
enum TDemoButtonType
{
	EDemoButtonTypeSetting = 0,
	EDemoButtonTypeVoiceRecognition,
    EDemoButtonTypeSDKUI
};

@class BDVRCustomRecognitonViewController;

// @class - BDVRViewController
// @brief - Sample主界面的实现类
@interface BDVRViewController : UIViewController<BDRecognizerViewDelegate, MVoiceRecognitionClientDelegate, BDVRDataUploaderDelegate>
{
	IBOutlet UIButton *settingButton;
	IBOutlet UIButton *voiceRecognitionButton;
	IBOutlet UIButton *voiceRecognitionSDKUIButton;
}

@property (nonatomic, assign) IBOutlet UITextView *logCatView;
@property (nonatomic, assign) IBOutlet UITextView *resultView;
@property (nonatomic, retain) BDVRCustomRecognitonViewController *audioViewController;
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
@property (nonatomic, retain) BDVRRawDataRecognizer *rawDataRecognizer;
@property (nonatomic, retain) BDVRFileRecognizer *fileRecognizer;
@property (nonatomic, retain) BDVRDataUploader *contactsUploader;


// --UI中按钮动作
- (IBAction)settingAction;
- (IBAction)voiceRecognitionAction;
- (IBAction)sdkUIRecognitionAction;
- (IBAction)audioDataRecognitionAciton;
- (IBAction)uploadContactsAction:(UIButton *)sender;

// --log & result
- (void)logOutToContinusManualResut:(NSString *)aResult;
- (void)logOutToManualResut:(NSString *)aResult;
- (void)logOutToLogView:(NSString *)aLog;

@end
