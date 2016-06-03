//
// Created by Baidu on 13-10-1.
// Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <Foundation/Foundation.h>

// @class - BDVRPickerTableViewCell
// @brief - 语音设置界面中的PicerView控件
@interface BDVRPickerTableViewCell : UITableViewCell <UIPopoverControllerDelegate>
{
    UIPopoverController *_popoverController;
    UIToolbar *_inputAccessoryView;
}

@property (nonatomic, retain) UIPickerView *pickerView;

@end // BDVRPickerTableViewCell