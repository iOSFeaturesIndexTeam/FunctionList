//
//  LWRouterHandle.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#ifndef LWRouterHandle_h
#define LWRouterHandle_h

//路由回调
typedef void(^LWRouteHandler)(id result,NSError *error);
typedef id LWParameters;

@protocol LWRouterDelegate
+ (NSString *)routePath;
+ (void)handleRequest:(LWParameters)parameters
    topViewController:(UIViewController *)topViewController
     optionHandle:(LWRouteHandler)optionHandle;
@end

#endif /* LWRouterHandle_h */
