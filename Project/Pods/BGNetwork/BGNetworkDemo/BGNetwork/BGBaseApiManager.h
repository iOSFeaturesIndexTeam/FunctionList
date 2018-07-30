//
//  BGBaseApiManager.h
//  BGNetworkDemo
//
//  Created by Little.Daddly on 2018/6/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetwork.h"

/**
 请求API管理者
 */


@protocol BGApiConfigDelegate <NSObject>

@required
/**
 Api默认的请求方式

 @return GET/POST
 */
- (BGRequestMethod)defaultRequestMethod;
/**
 服务器Path

 @return 返回不同环境下的path 【Test/Develop/Release】
 */
- (NSString *)serverDomainPath;

@optional

/**
 请求参数的公共处理 #warning : 下载和上传任务 默认没有实现接口
 
 @param requestParam 业务层的请求参数
 @param requestUrl 接口的url
 @return 处理后的请求参数
 */
- (NSDictionary *)parametersWithRequestParam:(NSDictionary *)requestParam
                                  requestUrl:(NSString *)requestUrl;
/**
 请求最大时长 【默认是3秒】

 @return 时长
 */
- (NSTimeInterval)requestTimeoutInterval;
/**
 数据请求格式 默认JSON

 @return 请求格式
 */
- (BTRequestSerializerType)requestSerializerType;
/**
 数据返回格式 默认JSON

 @return 返回格式
 */
- (BTResponseSerializerType)responseSerializerType;
/**
 请求头数据 key-value
 
 @return 字典数据 【用户登录Token】
 */
- (NSDictionary *)requestHeaderFieldDictionary;
@end

@interface BGBaseApiManager : NSObject
/** API 配置 */
@property (nonatomic,weak) id<BGApiConfigDelegate> apiConfigDelegate;
+ (instancetype)shareManager;

/**
 普通请求 【GET/POST】

 @param extraMethod 模块特殊接口 请求类型【GET/POST】
 @param url 请求url
 @param params 请求参数
 @param completionHandle 完成回调
 */
- (NSString *)dataRequestWithExtraMethod:(BGRequestMethod)extraMethod
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
 */
- (NSString *)uploadRequestWithUrl:(NSString *)url
                      params:(NSDictionary *)params
                  uploadType:(BGUploadType)uploadType
                       datas:(NSArray *)datas
               progressBlock:(BGProgressBlock)progress
            completionHandle:(BGNetworkCompletionBlcok)completionHandle;

/**
 下载任务

 @param url 请求url
 @param destinationBlock 存放地址回调
 @param progress 下载进度
 @param completionHandle 完成回调
 */
- (NSString *)downloadRequestWithUrl:(NSString *)url
              destinationBlock:(BGDestinationBlcok)destinationBlock
                 progressBlock:(BGProgressBlock)progress
              completionHandle:(BGNetworkCompletionBlcok)completionHandle;
@end
