//
//  LWRouter.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "LWRoute.h"
#import <objc/message.h>

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

- (id)handlerRequest:(LWRouteRequest *)request optionHandle:(LWRouteHandler)optionHandle{
    NSParameterAssert(request);
    if (request.routeType == LWRouteTypeJump) {
        Class<LWRouterDelegate> handler =_handlesM[request.routePath];
        UIViewController *_top_viewController = _lwGetTopVC();
        if (handler) {
           return [handler handleRequest:request
                 topViewController:_top_viewController
                      optionHandle:optionHandle];
        } else {
            NSLog(@"执行失败 未遵守路由协议");
            if (_unHandlerCallback) {
                _unHandlerCallback(request,_top_viewController);
            }
        }
    } else if (request.routeType == LWRouteTypeService) {
        
        
        NSArray *args = request.paramters?@[request.paramters]:@[rt_nilObj()];
        
        if (optionHandle) {
            args = @[args[0], optionHandle];
        } else {
            
            LWRouteHandler tempBlock = ^(id result,NSError *error) {};
            args = @[args[0], tempBlock];
        }
        
        
        NSArray *d = [request.routePath componentsSeparatedByString:@"/"];
        NSString *target_url = d.firstObject;
        NSString *servic_obj = d.lastObject;
        NSString *final_selector = [NSString stringWithFormat:@"routerHandle_%@:optionHandle:",servic_obj];
        Class handler = NSClassFromString(target_url);
//        Class<LWRouterDelegate> handler =_handlesM[target_url];
        
        SEL sel = NSSelectorFromString(final_selector);
        if (!sel) {
            
            NSString *eStr = [NSString stringWithFormat:@"*%@组件%@方法调用错误, 请检查调用的url", target_url, servic_obj];
            NSLog(@"%@",eStr);
            
        } else if (![(id)handler respondsToSelector:sel]) {
            
            NSString *eStr = [NSString stringWithFormat:@"*%@组件%@方法调用错误, 请检查调用的url", target_url, servic_obj];
            NSLog(@"%@",eStr);
            
        } else {
            NSError *err = nil;
            return [(id)handler RTCallSelectorWithArgArray:sel arg:args error:&err];
        }
        return nil;
    }
    

    return nil;
}

- (BOOL)canHandleRoutePath:(NSString *)routePath{
    if (!routePath || routePath.length == 0) {
        return NO;
    }
    return _handlesM[routePath];
}


@end
