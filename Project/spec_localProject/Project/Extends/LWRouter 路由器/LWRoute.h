//
//  LWRouter.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWRouteRequest.h"
#import "LWRouterMsgSend.h"

static UIViewController *_lwGetTopVC(){
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while ([vc isKindOfClass:[UINavigationController class]]
           || [vc isKindOfClass:[UITabBarController class]]) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc topViewController];
        } else if (vc.presentingViewController) {
            /** .presentedViewController  A --- prestent --- B
             A.presentedViewController 表示 是 B
             B.presentingViewController 表示 是 A
             */
            vc = vc.presentedViewController;
        }
        break;
    }
    return vc;
}
//路由未正确执行回调
typedef void(^LWRouteUnHandleCallback)(LWRouteRequest *request,UIViewController *topViewController);
typedef id LWParameters;

@interface LWRoute : NSObject

+ (instancetype)manager;
@property(nonatomic,copy)LWRouteUnHandleCallback unHandlerCallback;

/**
 处理路由跳转

 @param request 请求处理
 @param optionHandle 额外处理
 @return 处理结果
 */
- (id)handlerRequest:(LWRouteRequest *)request
          optionHandle:(LWRouteHandler)optionHandle;

/**
 是否支持路由格式

 @param routePath 路由路径
 @return 是否支持
 */
- (BOOL)canHandleRoutePath:(NSString *)routePath;
@end
