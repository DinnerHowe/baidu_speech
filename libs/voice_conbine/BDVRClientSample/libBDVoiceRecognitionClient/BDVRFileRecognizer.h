//
//  BDVRFileRecognizer.h
//  BDVoiceRecognitionClient
//
//  Created by Baidu on 13-11-13.
//  Copyright (c) 2013年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDVoiceRecognitionClient.h"
#import "BDVRRawDataRecognizer.h"

@interface BDVRFileRecognizer : BDVRRawDataRecognizer

@property (nonatomic, retain) NSString *filePath;

/**
 * @brief 初始化文件识别器
 *
 * @param filePath 文件路径
 *
 * @param sampleRate 采样率
 *
 * @param mode 识别模式
 *
 * @param delegate 代理对象
 *
 * @return 状态码
 */
- (id)initFileRecognizerWithFilePath:(NSString *)filePath sampleRate:(int)rate property:(TBDVoiceRecognitionProperty)property delegate:(id<MVoiceRecognitionClientDelegate>)delegate __attribute__((deprecated));


/**
 * @brief 初始化文件识别器
 *
 * @param filePath 文件路径
 *
 * @param sampleRate 采样率
 *
 * @param propList 识别属性数组
 *
 * @param cid 城市id
 *
 * @param delegate 代理对象
 *
 * @return 状态码
 */
- (id)initFileRecognizerWithFilePath:(NSString *)filePath
                          sampleRate:(int)rate
                       propertyGroup:(NSArray*)propList
                              cityID:(NSInteger)cid
                            delegate:(id<MVoiceRecognitionClientDelegate>)delegate;

/**
 * @brief 发起一次文件识别
 *
 * @return 状态码，-1表示文件不存在，其余同[BDVoiceRecognitionClient startVoiceRecognition]
 */
- (int)startFileRecognition;

@end
