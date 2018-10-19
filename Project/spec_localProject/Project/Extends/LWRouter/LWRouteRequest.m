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
                              paramters:(LWParameters _Nullable )paramters{
    if (self = [super init]) {
        _routePath = routePath;
        _paramters = paramters;
    }
    return self;
}
@end

@implementation LWRouteRequest(CreateByURL)
- (instancetype)initWithURL:(NSURL *)URL{
    if (self = [super init]) {
        self = [self initWithPath:@"" paramters:nil];
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
