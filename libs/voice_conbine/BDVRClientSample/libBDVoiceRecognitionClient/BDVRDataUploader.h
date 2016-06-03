//
//  BDVRDataUploader.h
//  VoiceRecognitionClient
//
//  Created by  段弘 on 14-5-21.
//  Copyright (c) 2014年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BDVR_DATA_UPLOADER_ERROR_DOMAIN @"BDVRDataUploaderErrorDomain"

@class BDVRDataUploader;

// 枚举 - 语音识别错误通知状态分类
enum TDataUploaderError
{
    EDataUploaderRequestError = 4001,        // 网络请求发生错误
    EDataUploaderResponseParseError = 4002   // 服务器数据解析错误
};

@protocol BDVRDataUploaderDelegate <NSObject>

/**
 * @brief 通知数据上传结果
 *
 * @param error 错误信息，error.code == 0表示无错误
 */
-(void)onComplete:(BDVRDataUploader *)dataUploader error:(NSError *)error;

@end

@interface BDVRDataUploader : NSObject

/**
 * @brief 服务器地址，请仅在测试时设置
 */
@property (nonatomic, copy) NSString *serverURL;
/**
 * @brief 上传事件通知代理
 */
@property (nonatomic, assign) id<BDVRDataUploaderDelegate> delegate;
/**
 * @brief 产品ID，请向语音组申请，与应用bundle id绑定
 */
@property (nonatomic, copy) NSString *productID;

/**
 * @brief 初始化BDVRDataUploader示例
 *
 * @param delegate 代理对象
 */
- (instancetype)initDataUploader:(id<BDVRDataUploaderDelegate>)delegate;

/**
 * @brief 设置开发者申请的api key和secret key
 *
 * @param apiKey
 * @param secretKey
 */
- (void)setApiKey:(NSString *)apiKey withSecretKey:(NSString *)secretKey;

/**
 * 上传联系人数据，如果前一次上传任务未完成，任务将被取消
 * 请通过实现BDVRDataUploaderDelegate监听上传任务状态
 *
 * @param data 联系人数据
 */
- (void)uploadContactsData:(NSData *)data;

/**
 * @brief 取消本次上传
 */
- (void)cancelUpload;

@end
