//
//  BDVRClientUIManager.m
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25.
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import "BDVRClientUIManager.h"

@implementation BDVRClientUIManager

#pragma mark - init & dealloc
- (id)init 
{
	self = [super init];
 	if (self) 
    {
        //
	}
	return self;
}

+ (BDVRClientUIManager *)sharedInstance 
{
	static BDVRClientUIManager *_sharedInstance = nil;
	if (_sharedInstance == nil)
		_sharedInstance = [[BDVRClientUIManager alloc] init];
	return _sharedInstance;
}

#pragma mark - UIManager Methods

- (CGRect)VRBackgroundFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)VRRecordTintWordFrame
{
	return CGRectMake(0.0f, 0.0f, 260.0f, 42.0f);
}

- (CGRect)VRRecognizeTintWordFrame
{
	return CGRectMake(0.0f, 0.0f, 260.0f, 42.0f);
}

- (CGRect)VRLeftButtonFrame
{
	return CGRectMake(0.0f, 214.0f - 58.0f, 144.0f, 52.0f);
}

- (CGRect)VRRightButtonFrame
{
	return CGRectMake(144.0f, 214.0f - 58.0f, 145.0f, 52.0f);
}

- (CGRect)VRCenterButtonFrame
{
	return CGRectMake(0.0f, 0.0f, 260.0f, 52.0f);
}

#pragma mark center point

- (CGPoint)VRRecordBackgroundCenter
{
    return CGPointMake(145.0f, 56.0f);
}

- (CGPoint)VRRecognizeBackgroundCenter
{
    return CGPointMake(145.0f, 46.0f);
}

- (CGPoint)VRTintWordCenter
{
    return CGPointMake(145.0f, 120.0f);
}

- (CGPoint)VRCenterButtonCenter
{
    return CGPointMake(145.0f, 182.0f);
}

- (CGRect)VRDemoWebViewFrame
{
    return CGRectMake(13.0f, 302.0f, 294.0f, 147.0f);
}

- (CGRect)VRDemoPicerViewFrame
{
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    return CGRectMake((screenSize.width - 320) / 2, screenSize.height - 261, 320, 261);
}

- (CGRect)VRDemoPicerBackgroundViewFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

@end // BDVRClientUIManager
