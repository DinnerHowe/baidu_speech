//
//  BDVRUIPromptTextCustom.h
//  VoiceRecognitionClient
//
//  Created by  段弘 on 13-12-26.
//  Copyright (c) 2013年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDVRUIPromptTextCustom : NSObject

@property (nonatomic, retain) NSString *startSpeak;
@property (nonatomic, retain) NSString *pleaseWait;
@property (nonatomic, retain) NSString *buttonInitializing;
@property (nonatomic, retain) NSString *pleaseSpeak;
@property (nonatomic, retain) NSString *listening;
@property (nonatomic, retain) NSString *statusRecognizing;
@property (nonatomic, retain) NSString *waitNetworking;
@property (nonatomic, retain) NSString *cancelVR;
@property (nonatomic, retain) NSString *help;
@property (nonatomic, retain) NSString *retry;
@property (nonatomic, retain) NSString *speakFinish;
@property (nonatomic, retain) NSString *buttonRecognizing;
@property (nonatomic, retain) NSString *baiduSupportLabel;
@property (nonatomic, retain) NSString *networkError;
@property (nonatomic, retain) NSString *networkError2;
@property (nonatomic, retain) NSString *networkUnavailable;
@property (nonatomic, retain) NSString *serverError;
@property (nonatomic, retain) NSString *resultError;
@property (nonatomic, retain) NSString *clientError;
@property (nonatomic, retain) NSString *unknownError;
@property (nonatomic, retain) NSString *noSpeech;
@property (nonatomic, retain) NSString *speechTooShort;
@property (nonatomic, retain) NSString *speechBadQuality;
@property (nonatomic, retain) NSString *speechTooLong;
@property (nonatomic, retain) NSString *recordInterrupted;
@property (nonatomic, retain) NSString *noMicrophone;
@property (nonatomic, retain) NSString *noMicrophonePermission;
@property (nonatomic, retain) NSString *noAPIKey;
@property (nonatomic, retain) NSString *getAccessTokenFailed;
@property (nonatomic, retain) NSString *propertyError;
@property (nonatomic, retain) NSString *verifyLicenseFaild;
@property (nonatomic, retain) NSString *offlineEngineInitFailed;
@property (nonatomic, retain) NSString *offlineEngineNotInited;
@property (nonatomic, retain) NSString *offlineEngineNotSupport;

+ (instancetype)sharedInstance;

@end
