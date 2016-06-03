//
//  BDRecognizerViewDelegate.h
//  BDVoiceRecognitionClient
//
//  Created by baidu on 13-9-23.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BDRecognizerViewController;

/**
 * @brief - 语音弹窗UI的委托接口
 */
@protocol BDRecognizerViewDelegate <NSObject>

/**
 * @brief 语音识别结果返回，搜索和输入模式结果返回的结构不相同
 *
 * @param aBDRecognizerView 弹窗UI
 * @param aResults 返回结果，搜索结果为数组，输入结果也为数组，但元素为字典
 */
- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults;

@optional
/**
 * @brief 录音数据返回
 *
 * @param recordData 录音数据
 * @param sampleRate 采样率
 */
- (void)onRecordDataArrived:(NSData *)recordData sampleRate:(int)sampleRate;

/**
 * @brief 录音结束
 */
- (void)onRecordEnded;

/**
 * @brief 返回中间识别结果
 *
 * @param results
 *            中间识别结果
 */
- (void)onPartialResults:(NSString *)results;

/**
 * @brief 发生错误
 *
 * @param errorCode
 *            错误码
 */
- (void)onError:(int)errorCode;

/**
 * @brief 提示语出现
 */
- (void)onTipsShow;

- (void)onSpeakFinish;

- (void)onRetry;

/**
 * @brief 弹窗关闭
 */
- (void)onClose;

@end

/**
 * @brief 语音输入弹窗按钮的委托接口，开发者不需要关心
 */
@protocol BDRecognizerDialogDelegate <NSObject>

@required
- (void)voiceRecognitionDialogHelp; // 出现帮助界面
- (void)voiceRecognitionDialogClosed; // 对话框关闭
- (void)voiceRecognitionDialogRetry; // 用户重试
- (void)voiceRecognitionDialogSpeekFinish; // 说完了

@end // BDRecognizerDialogDelegate
