//
//  BGBaseApiManager.m
//  BGNetworkDemo
//
//  Created by Little.Daddly on 2018/6/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BGBaseApiManager.h"
#import "BGNetworkManager.h"

@interface  BGBaseApiManager()
@end


@implementation BGBaseApiManager
+ (instancetype)shareManager{
    BGBaseApiManager *apiManager = [self new];
    return apiManager;
}
- (void)dealloc {NSLog(@"%@ ---- dalloc ", NSStringFromClass([self class]));}
                       
- (instancetype)init{
    if (self = [super init]) {
        if ([self respondsToSelector:@selector(defaultRequestMethod)]
            && [self respondsToSelector:@selector(serverDomainPath)]) {
            self.apiConfigDelegate = (id<BGApiConfigDelegate>)self;
        } else {
            NSAssert(NO, @"必须实现 BTApiConfigDelegate 中require的接口！！");
        }
    }
    return self;
}

#pragma mark - custom Method
- (NSString *)dataRequestWithExtraMethod:(BGRequestMethod)extraMethod url:(NSString *)url params:(NSDictionary *)params completionHandle:(BGNetworkCompletionBlcok)completionHandle{
   return [[BGNetworkManager shareManager] dataRequestWithApiManager:self
                                                   extraMethod:extraMethod
                                                           url:url
                                                        params:params
                                              completionHandle:completionHandle];
}

- (NSString *)uploadRequestWithUrl:(NSString *)url
                      params:(NSDictionary *)params
                  uploadType:(BGUploadType)uploadType
                       datas:(NSArray *)datas
               progressBlock:(BGProgressBlock)progress
            completionHandle:(BGNetworkCompletionBlcok)completionHandle{

   return [[BGNetworkManager shareManager] uploadRequestWithApiManager:self
                                                             url:url
                                                          params:params
                                                      uploadType:uploadType
                                                           datas:datas
                                                   progressBlock:progress
                                                completionHandle:completionHandle];
}

- (NSString *)downloadRequestWithUrl:(NSString *)url
              destinationBlock:(BGDestinationBlcok)destinationBlock
                 progressBlock:(BGProgressBlock)progress
              completionHandle:(BGNetworkCompletionBlcok)completionHandle{
    return [[BGNetworkManager shareManager] downloadRequestWithApiManager:self
                                                               url:url
                                                  destinationBlock:destinationBlock
                                                     progressBlock:progress
                                                  completionHandle:completionHandle];
}
@end
