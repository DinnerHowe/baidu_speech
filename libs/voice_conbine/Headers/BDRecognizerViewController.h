//
//  BDRecognizerViewController.h
//  BDVoiceRecognitionClient
//
//  Created by Baidu on 13-9-25.
//  Copyright (c) 2013 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BDRecognizerViewDelegate.h"
#import "BDVoiceRecognitionClient.h"
#import "BDRecognizerViewParamsObject.h"
#import "BDTheme.h"

/**
 * @brief 语音识别弹窗视图控制类
 */
@interface BDRecognizerViewController : UIViewController<MVoiceRecognitionClientDelegate, BDRecognizerDialogDelegate, AVAudioPlayerDelegate>
{
    id<BDRecognizerViewDelegate> delegate;
}

@property (assign) id<BDRecognizerViewDelegate> delegate; // 识别结果delegate
@property (nonatomic, readonly) BDTheme *recognizerViewTheme; // 得到当前的主题
@property (nonatomic, assign) BOOL enableFullScreenMode; // 全屏模式

/**
 * @brief 创建弹窗实例
 * @param origin 控件左上角的坐标
 * @param theme 控件的主题，如果为nil，则为默认主题
 *
 * @return 弹窗实例
 */
- (id)initWithOrigin:(CGPoint)origin withTheme:(BDTheme *)theme;

/**
 * @brief 启动识别
 * @param params 识别过程的参数，具体项目参考BDRecognizerViewParamsObject类声明，注意参数不能为空，必须要设置apiKey和secretKey
 *
 * @return 开始识别是否成功，成功为YES，否则为NO
 */
- (BOOL)startWithParams:(BDRecognizerViewParamsObject *)params;

/**
 * @brief - 取消本次识别，并移除View
 */
- (void)cancel;

/**
 * @brief 屏幕旋转后调用设置识别弹出窗位置
 *
 */
- (void)changeFrameAfterOriented:(CGPoint)origin;
@end // BDRecognizerViewController
