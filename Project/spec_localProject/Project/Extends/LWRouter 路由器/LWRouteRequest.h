//
//  LWRouterRequest.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LWRouteHandle.h"
typedef NS_ENUM(NSUInteger,LWRouteType) {
    LWRouteTypeService = 1,
    LWRouteTypeJump
};
NS_ASSUME_NONNULL_BEGIN
@interface LWRouteRequest : NSObject


/**
 路由跳转类型 通过runtime 代理的方式实现

 @param routePath 路径
 @param param 参数
 @return 回调
 */
+ (LWRouteRequest *)requestWithPath:(NSString *)routePath
                           andParam:(LWParameters)param;

/**
 路由服务类型   通过消息转发实现

 @param routePath 模块/服务Action
 @param param 参数
 @return 回调
 */
+ (LWRouteRequest *)requestServicePath:(NSString *)routePath
                           andParam:(LWParameters)param;

@property(nonatomic,copy,readonly)NSString *routePath;
@property(nonatomic,strong,readonly)LWParameters paramters;
@property (nonatomic,assign,readonly) LWRouteType routeType;
@end


@interface LWRouteRequest(CreateByURL)
- (instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic,strong,nullable) NSURL *originalURL;

@end
NS_ASSUME_NONNULL_END
