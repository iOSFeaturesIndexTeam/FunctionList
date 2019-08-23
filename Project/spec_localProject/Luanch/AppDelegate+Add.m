//
//  AppDelegate+Add.m
//  spec_localProject
//
//  Created by Little.Daddly on 2019/8/23.
//  Copyright © 2019 Little.Daddly. All rights reserved.
//

#import "AppDelegate+Add.h"
#import "Vip.h"

@implementation AppDelegate (Add)
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    AppDelegate *app = [super allocWithZone:zone];
    
    [[app rac_signalForSelector:@selector(application:didFinishLaunchingWithOptions:)] subscribeNext:^(RACTuple * _Nullable x) {
        [Vip application:x.first didFinishLaunchingWithOptions:x.second];
    }];

    
    return app;
}
@end
