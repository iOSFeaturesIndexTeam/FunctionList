//
//  LWRouter.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "LWRoute.h"
#import <objc/message.h>
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

@interface LWRoute()
//key:路由路径 value:路径映射VC
@property(nonatomic,strong) NSMutableDictionary <NSString *,Class<LWRouterDelegate>> *handlesM;
@end

@implementation LWRoute
+ (instancetype)manager {
    static LWRoute *route = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        route = [LWRoute new];
    });
    return route;
}

- (instancetype)init{
    if (self = [super init]) {
        //将运行编译后的calss加载到handkesM中
        _handlesM = [NSMutableDictionary new];
        unsigned int img_count = 0;
        //获取加载objc中的框架和动态库的名称
        const char **imgs = objc_copyImageNames(&img_count);
        const char *main = NSBundle.mainBundle.bundlePath.UTF8String;
        for (unsigned int i = 0; i < img_count; ++i) {
            const char *img = imgs[i];
            //跳过没有使用到项目中的 框架 和动态库
            if (!strstr(img, main)) {
                continue;
            }
            unsigned int cls_count = 0;
            //获取指定库或者框架中所有类的类名
            const char **classes = objc_copyClassNamesForImage(img, &cls_count);
            Protocol *p_hander = @protocol(LWRouterDelegate);
            for (unsigned int i = 0; i < cls_count; ++i) {
                const char *cls_name = classes[i];
                NSString *cls_str =[NSString stringWithUTF8String:cls_name];
                
                Class cls = NSClassFromString(cls_str);
                
                if (![cls conformsToProtocol:p_hander]) continue;
                if (![(id)cls respondsToSelector:@selector(routePath)]) continue;
                if (![(id)cls respondsToSelector:@selector(handleRequest:topViewController:optionHandle:)]) continue;
                
                [_handlesM setValue:cls forKey:[(id<LWRouterDelegate>)cls routePath]];
            }
            if (classes) free(classes);
        }
        
        if (imgs) free(imgs);
    }
    return self;
}

- (void)handlerRequest:(LWRouteRequest *)request optionHandle:(LWRouteHandler)optionHandle{
    NSParameterAssert(request);
    Class<LWRouterDelegate> handler =_handlesM[request.routePath];
    UIViewController *_top_viewController = _lwGetTopVC();
    if (handler) {
        [handler handleRequest:request
             topViewController:_top_viewController
              optionHandle:optionHandle];
    } else {
        NSLog(@"执行失败 未遵守路由协议");
        if (_unHandlerCallback) {
            _unHandlerCallback(request,_top_viewController);
        }
    }
    
}

- (BOOL)canHandleRoutePath:(NSString *)routePath{
    if (!routePath || routePath.length == 0) {
        return NO;
    }
    return _handlesM[routePath];
}
@end
