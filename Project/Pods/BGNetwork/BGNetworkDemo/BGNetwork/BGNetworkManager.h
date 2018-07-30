//
//  BGNetworkManager.h
//  BGNetworkDemo
//
//  Created by Little.Daddly on 2018/6/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BGNetwork.h"
@class BGBaseApiManager;
@interface BGNetworkManager : NSObject

+ (instancetype)shareManager;
/** 请求支持的格式 */
+ (NSSet<NSString *> *)NetworkAcceptableContentTypes;

/**
 普通请求 【GET/POST】
 
 @param apiManager 当前请求接口对象
 @param extraMethod 模块特殊接口 请求类型【GET/POST】
 @param url 请求url
 @param params 请求参数
 @param completionHandle 完成回调
 @return 任务id
 */
- (NSString *)dataRequestWithApiManager:(BGBaseApiManager *)apiManager
                      extraMethod:(BGRequestMethod)extraMethod
                               url:(NSString *)url
                            params:(NSDictionary *)params
                  completionHandle:(BGNetworkCompletionBlcok)completionHandle;

/**
 上传任务

 @param url 接口url
 @param params 拼接参数
 @param uploadType 上传类型
 @param datas 上传数据
 @param progress 上传进度
 @param completionHandle 完成回调
 @return 任务id
 */
- (NSString *)uploadRequestWithApiManager:(BGBaseApiManager *)apiManager
                                url:(NSString *)url
                             params:(NSDictionary *)params
                         uploadType:(BGUploadType)uploadType
                              datas:(NSArray *)datas
                      progressBlock:(BGProgressBlock)progress
                   completionHandle:(BGNetworkCompletionBlcok)completionHandle;

/**
 下载任务
 
 @param apiManager 当前请求接口对象
 @param url 请求url
 @param destinationBlock 存放地址回调
 @param progress 下载进度
 @param completionHandle 完成回调
 @return 任务id
 */
- (NSString *)downloadRequestWithApiManager:(BGBaseApiManager *)apiManager
                                  url:(NSString *)url
                     destinationBlock:(BGDestinationBlcok)destinationBlock
                        progressBlock:(BGProgressBlock)progress
                     completionHandle:(BGNetworkCompletionBlcok)completionHandle;

/**
 通过UnionId取消任务

 @param unionId 任务Id
 */
- (void)cancelTaskWithUnionId:(NSString *)unionId;
/**
 取消所有任务
 */
- (void)cancelAllTask;
@end
