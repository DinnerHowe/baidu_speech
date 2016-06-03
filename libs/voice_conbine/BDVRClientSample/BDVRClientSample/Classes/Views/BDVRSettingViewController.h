//
//  VRSettingViewController.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25.
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <UIKit/UIKit.h>

@class BDVRViewController;

// @class - BDVRSettingViewController
// @brief - Sample设置界面的实现类
@interface BDVRSettingViewController : UITableViewController <UIPickerViewDelegate>
{
    BDVRViewController *clientSampleViewController;
}

@property (nonatomic, assign) BDVRViewController *clientSampleViewController;

@end // VRSettingViewController
