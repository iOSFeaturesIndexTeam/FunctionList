//
//  BGNetworkManager.m
//  BGNetworkDemo
//
//  Created by Little.Daddly on 2018/6/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BGNetworkManager.h"
#import "BGBaseApiManager.h"
@interface BGHTTPSessionManager : AFHTTPSessionManager
- (instancetype)initWithApiManager:(BGBaseApiManager *)apiManager;
    
@end
@implementation BGHTTPSessionManager
- (instancetype)initWithApiManager:(BGBaseApiManager *)apiManager{
    if (self = [super init]) {
        self =(BGHTTPSessionManager *)[AFHTTPSessionManager manager];
        /** 返回类型 */
        if ([apiManager.apiConfigDelegate respondsToSelector:@selector(responseSerializerType)]) {
            switch (apiManager.apiConfigDelegate.responseSerializerType) {
                case BTResponseSerializerTypeHTTP:
                    self.responseSerializer = [AFHTTPResponseSerializer serializer];break;
                case BTResponseSerializerTypeJSON:
                {
                    self.responseSerializer = [AFJSONResponseSerializer serializer];
                    ((AFJSONResponseSerializer *)self.responseSerializer).removesKeysWithNullValues = YES;
                    break;
                }
                default:
                    break;
            }
        }
        
        /** 支持格式 */
        self.responseSerializer.acceptableContentTypes = [BGNetworkManager NetworkAcceptableContentTypes];

        /** 发送类型 */
        if ([apiManager.apiConfigDelegate respondsToSelector:@selector(requestSerializerType)]) {
            switch (apiManager.apiConfigDelegate.requestSerializerType) {
                case BTRequestSerializerTypeHTTP:
                    self.requestSerializer = [AFHTTPRequestSerializer serializer];break;
                case BTRequestSerializerTypeJSON:
                    self.requestSerializer = [AFJSONRequestSerializer serializer];break;
                default:
                    break;
            }
        }
        
        /** 超时 时长 */
        if ([apiManager.apiConfigDelegate respondsToSelector:@selector(requestTimeoutInterval)]) {
            self.requestSerializer.timeoutInterval = apiManager.apiConfigDelegate.requestTimeoutInterval;
        } else {
            self.requestSerializer.timeoutInterval = kDEFAULT_REQUEST_TIMEOUT;
        }
        /** 请求头 */
        if ([apiManager.apiConfigDelegate respondsToSelector:@selector(requestHeaderFieldDictionary)]) {
            [apiManager.apiConfigDelegate.requestHeaderFieldDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]]) {
                    [self.requestSerializer setValue:obj forHTTPHeaderField:key];
                }
            }];
        }
        
    }
    return self;
}
@end

@interface BGNetworkManager ()
@property (nonatomic,strong) NSMutableDictionary *taskTable;
@end

@implementation BGNetworkManager
+ (instancetype)shareManager{
    static BGNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BGNetworkManager new];
    });
    return manager;
}

-(void)dealloc{NSLog(@"dalloc -- %@",NSStringFromClass([self class]));}

- (instancetype)init {
    if (self = [super init]) {
        _taskTable = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - custom Method
- (NSString *)dataRequestWithApiManager:(BGBaseApiManager *)apiManager
                      extraMethod:(BGRequestMethod)extraMethod
                              url:(NSString *)url
                           params:(NSDictionary *)params
                 completionHandle:(BGNetworkCompletionBlcok)completionHandle{
    BGHTTPSessionManager *sessionManager = [[BGHTTPSessionManager alloc] initWithApiManager:apiManager];
    
    /** 获取api中的环境 拼接接口 参数 是否要修改接口请求类型【GET/POST】 */
    NSURLRequest *urlRequest = [self urlRequestWithSessionManager:sessionManager
                                                       apiManager:apiManager
                                                      extraMethod:extraMethod
                                                       requestUrl:url
                                                     requestParam:params];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSString *task_id = intToString(dataTask.taskIdentifier);
        [sessionManager invalidateSessionCancelingTasks:YES];
        
        @synchronized(self.taskTable) {
            if ([self.taskTable.allKeys containsObject:task_id]) {
                [self.taskTable removeObjectForKey:task_id];
            }
        }
        
        if (completionHandle) {
            completionHandle(responseObject, error);
        }
    }];
    
    NSString *task_id = intToString(dataTask.taskIdentifier);
    @synchronized(self.taskTable) {
        [self.taskTable setValue:dataTask forKey:task_id];
    }

    [dataTask resume];
    return task_id;
}

- (NSString *)uploadRequestWithApiManager:(BGBaseApiManager *)apiManager
                                url:(NSString *)url
                             params:(NSDictionary *)params
                         uploadType:(BGUploadType)uploadType
                              datas:(NSArray *)datas
                      progressBlock:(BGProgressBlock)progress
                   completionHandle:(BGNetworkCompletionBlcok)completionHandle{
    NSAssert(url, @"上传任务 url 不可为空");
    BGHTTPSessionManager *manager = [[BGHTTPSessionManager alloc] initWithApiManager:apiManager];
    NSError *error = nil;
    NSLog(@"requestMethod# %@ \n http_url# %@ \n params# %@",@"POST",url,params);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        switch (uploadType) {
            case BGUploadTypeImg:
            {
                for (UIImage *img in datas) {
                    if ([img isKindOfClass:[UIImage class]]) {
                        NSData *data = [BGNetworkManager compressImage:img toMaxFileSize:1024];
                        [formData appendPartWithFileData:data
                                                    name:kServerImagePath
                                                fileName:@".png"
                                                mimeType:@"image/png"];
                    }
                }
            }
                break;
            case BGUploadTypeImgPath:
            {
                for (NSString *file_img in datas) {
                    if ([file_img isKindOfClass:[NSString class]]) {
                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:file_img]
                                                   name:kServerImagePath
                                               fileName:@".png"
                                               mimeType:@"image/png"
                                                  error:nil];
                    }
                }
            }
                break;
            case BGUploadTypeFilePath:
            {
                for (NSString *file in datas) {
                    if ([file isKindOfClass:[NSString class]]) {
                        NSData *data = [NSData dataWithContentsOfFile:file];
                        [formData appendPartWithFileData:data
                                                    name:kServerFilePath
                                                fileName:@".file"
                                                mimeType:@"image/png"];
                    }
                }
            }
                break;
            case BGUploadTypeZipPath:
            {
                for (NSString *file in datas) {
                    if ([file isKindOfClass:[NSString class]]) {
                        NSData *data = [NSData dataWithContentsOfFile:file];
                        [formData appendPartWithFileData:data
                                                    name:kServerZipPath
                                                fileName:@".zip"
                                                mimeType:@"zip"];
                    }
                }
            }
                break;
            default:
                break;
        }
    } error:&error];

    if (error) {
        completionHandle(nil,error);
        return nil;
    } else {
        NSURLSessionUploadTask *dataTask = nil;
        dataTask = [manager uploadTaskWithStreamedRequest:request
                                                 progress:progress
                                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSString *task_id = intToString(dataTask.taskIdentifier);
            [manager invalidateSessionCancelingTasks:YES];
            
            @synchronized(self.taskTable) {
                if ([self.taskTable.allKeys containsObject:task_id]) {
                    [self.taskTable removeObjectForKey:task_id];
                }
            }
            
            completionHandle(responseObject,error);
        }];
        
        NSString *task_id = intToString(dataTask.taskIdentifier);
        @synchronized(self.taskTable) {
            [self.taskTable setValue:dataTask forKey:task_id];
        }
        [dataTask resume];
        return task_id;
    }
}

- (NSString *)downloadRequestWithApiManager:(BGBaseApiManager *)apiManager
                                  url:(NSString *)url
                     destinationBlock:(BGDestinationBlcok)destinationBlock
                        progressBlock:(BGProgressBlock)progress
                     completionHandle:(BGNetworkCompletionBlcok)completionHandle{
    NSLog(@"http_url# %@",url);
    BGHTTPSessionManager *manager = [[BGHTTPSessionManager alloc] initWithApiManager:apiManager];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadTask = nil;
    downloadTask = [manager downloadTaskWithRequest:request
                                           progress:progress
                                        destination:destinationBlock
                                  completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                      NSString *task_id = intToString(downloadTask.taskIdentifier);
                                                                      [manager invalidateSessionCancelingTasks:YES];
                                                                      
                                                                      @synchronized(self.taskTable) {
                                                                          if ([self.taskTable.allKeys containsObject:task_id]) {
                                                                              [self.taskTable removeObjectForKey:task_id];
                                                                          }
                                                                      }
                                                                      if (completionHandle) {
                                                                          completionHandle(filePath, error);
                                                                      }
                                                                  }];
    NSString *task_id = intToString(downloadTask.taskIdentifier);
    @synchronized(self.taskTable) {
        [self.taskTable setValue:downloadTask forKey:task_id];
    }
    [downloadTask resume];
    return task_id;
}

- (NSURLRequest *)urlRequestWithSessionManager:(BGHTTPSessionManager *)sessionManager
                                    apiManager:(BGBaseApiManager *)apiManager
                                   extraMethod:(BGRequestMethod)extraMethod
                                    requestUrl:(NSString *)requestUrl
                                  requestParam:(NSDictionary *)requestParam{
    //当前环境 下 请求的接口
    NSString *http_url = [self getRequestHttp_url:requestUrl withApiManager:apiManager];
    
    NSString *requestType = @"GET";
    switch (extraMethod) {
        case BGRequestMethodDefault:
        {
            if (apiManager.apiConfigDelegate.defaultRequestMethod == BGRequestMethodPost) {
                requestType = @"POST";
            }
        }
            break;
        case BGRequestMethodGet:
            break;
        case BGRequestMethodPost:
            requestType = @"POST";
            break;
        default:
            break;
    }
    
    NSDictionary *params = [self parametersWithApiManager:apiManager requestParam:requestParam requestUrl:requestUrl];
    NSLog(@"\n requestMethod# %@ \n url:  %@ \n params:   %@",requestType,http_url,params);
    
    http_url = [http_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *params_m = [NSMutableDictionary dictionary];
    for (NSString *key in params.allKeys) {
        if ([params[key] isKindOfClass:[NSString class]]) {
            NSString *new_key = nil;
            NSString *new_value = nil;
            new_key = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            new_value = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [params_m setValue:new_value forKey:new_key];
        } else {
            [params_m setValue:params[key] forKey:key];
        }
    
    }
    
    NSURLRequest *urlRequest = nil;
  
    urlRequest = [[sessionManager requestSerializer] requestWithMethod:requestType
                                                             URLString:http_url
                                                            parameters:params
                                                                 error:nil];

    return urlRequest;
}

- (NSDictionary *)parametersWithApiManager:(BGBaseApiManager *)apiManager requestParam:(NSDictionary *)requestParam requestUrl:(NSString *)requestUrl {
    if ([apiManager.apiConfigDelegate respondsToSelector:@selector(parametersWithRequestParam:requestUrl:)]) {
        requestParam = [apiManager.apiConfigDelegate parametersWithRequestParam:requestParam
                                                                   requestUrl:requestUrl];
    }
    
    return requestParam;
}

- (void)cancelTaskWithUnionId:(NSString *)unionId{
    if ([self.taskTable objectForKey:unionId]) {
        NSURLSessionDataTask *requestTask = [self.taskTable objectForKey:unionId];
        if ([requestTask isKindOfClass:[NSURLSessionDownloadTask class]]) {
            //手动取消的下载请求，调用cancelByProducingResumeData:，这样回调的error中会带有resumeData
            NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)requestTask;
            [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                
            }];
        } else {
            [requestTask cancel];
        }
        [self.taskTable removeObjectForKey:unionId];
    }
}

- (void)cancelAllRequests{
    for (NSString *requestId in self.taskTable.allKeys) {
        [self cancelTaskWithUnionId:requestId];
    }
}

#pragma mark - Getter & Setter
+ (NSSet<NSString *> *)NetworkAcceptableContentTypes{
    return [NSSet setWithObjects:@"application/json",
                                 @"text/html",
                                 @"text/json",
                                 @"text/plain",
                                 @"text/javascript",
                                 @"text/xml",
                                 @"image/*",nil];
}

- (NSString *)getRequestHttp_url:(NSString *)url withApiManager:(BGBaseApiManager *)apiManager{
    if ([url hasPrefix:@"http"]) {
        return url;
    } else {
        return [apiManager.apiConfigDelegate.serverDomainPath stringByAppendingString:url];
    }
}

+ (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }

    return imageData;
}
@end
