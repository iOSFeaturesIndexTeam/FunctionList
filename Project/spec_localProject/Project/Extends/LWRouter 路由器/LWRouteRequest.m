//
//  LWRouterRequest.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "LWRouteRequest.h"
#import <objc/message.h>
NS_ASSUME_NONNULL_BEGIN
@implementation LWRouteRequest
- (instancetype _Nullable )initWithPath:(nonnull NSString *)routePath
                              routeType:(LWRouteType)routeType
                              paramters:(LWParameters _Nullable )paramters{
    if (self = [super init]) {
        _routePath = routePath;
        _paramters = paramters;
        _routeType = routeType;
    }
    return self;
}

+ (LWRouteRequest *)requestWithPath:(NSString *)routePath
                           andParam:(LWParameters)param{
    return [[LWRouteRequest alloc] initWithPath:routePath routeType:LWRouteTypeJump paramters:param];
}

+ (LWRouteRequest *)requestServicePath:(NSString *)routePath
                              andParam:(LWParameters)param{
    return [[LWRouteRequest alloc] initWithPath:routePath routeType:LWRouteTypeService paramters:param];
}
@end

@implementation LWRouteRequest(CreateByURL)
- (instancetype)initWithURL:(NSURL *)URL{
    if (self = [super init]) {
        self = [self initWithPath:@"" routeType:LWRouteTypeJump paramters:nil];
        self.originalURL = URL;
    }
    return self;
}
- (void)setOriginalURL:(NSURL * _Nullable)originalURL {
    objc_setAssociatedObject(self, @selector(originalURL), originalURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURL *_Nullable)originalURL {
    return objc_getAssociatedObject(self, _cmd);
}

@end
NS_ASSUME_NONNULL_END
