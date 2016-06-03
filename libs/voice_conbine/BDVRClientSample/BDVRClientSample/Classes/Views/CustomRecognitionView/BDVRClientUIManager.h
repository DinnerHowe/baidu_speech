//
//  BDVRClientUIManager.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25.
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <Foundation/Foundation.h>

// @class - BDVRClientUIManager
// @brief - VoiceRecognitonViewController的UI布局
@interface BDVRClientUIManager : NSObject

// --类方法
+ (BDVRClientUIManager *)sharedInstance;

// --UI布局方法
- (CGRect)VRBackgroundFrame;
- (CGRect)VRRecordTintWordFrame;
- (CGRect)VRRecognizeTintWordFrame;
- (CGRect)VRLeftButtonFrame;
- (CGRect)VRRightButtonFrame;
- (CGRect)VRCenterButtonFrame;

- (CGPoint)VRRecordBackgroundCenter;
- (CGPoint)VRRecognizeBackgroundCenter;
- (CGPoint)VRTintWordCenter;
- (CGPoint)VRCenterButtonCenter;

- (CGRect)VRDemoPicerViewFrame;
- (CGRect)VRDemoPicerBackgroundViewFrame;
- (CGRect)VRDemoWebViewFrame;

@end // BDVRClientUIManager
