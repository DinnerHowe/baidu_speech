//
//  BDVRSConfig.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25.
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <Foundation/Foundation.h>

@class BDTheme;
// @class - BDVRSConfig
// @brief - Sample中公共接口和数据访问类
@interface BDVRSConfig : NSObject 
{
	BOOL playStartMusicSwitch; // 开始说话提示音开关
	BOOL playEndMusicSwitch; // 结束说话提示音开关
    int recognitionLanguage;
    BOOL resultContinuousShow; // 是否开启连续上屏
	BOOL voiceLevelMeter; // 音量级别开关
    BOOL uiHintMusicSwitch; // 识别控件提示音开关
	
	NSString *_libVersion;
}

// 属性
@property (nonatomic) BOOL playStartMusicSwitch;
@property (nonatomic) BOOL playEndMusicSwitch;
@property (nonatomic, retain) NSNumber *recognitionProperty;
@property (nonatomic) int recognitionLanguage;
@property (nonatomic) BOOL resultContinuousShow;
@property (nonatomic) BOOL voiceLevelMeter;
@property (nonatomic) BOOL uiHintMusicSwitch;
@property (nonatomic) BOOL isNeedNLU;
@property (nonatomic, retain) NSString *libVersion;
@property (nonatomic, retain) BDTheme *theme;

// --类方法
+ (BDVRSConfig *)sharedInstance;

// 组织输入模式下返回
- (NSString *)composeInputModeResult:(id)aObj;

@end
