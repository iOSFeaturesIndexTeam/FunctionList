//
//  RefrigeratorFactory.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "RefrigeratorFactory.h"

@implementation RefrigeratorFactory
+ (instancetype)product{
    return [RefrigeratorFactory new];
}

- (void)productInfo {
    KCLog(@"冰箱 外壳%@，制冷器厂商%@",self.baseData,self.Cooler);
}

- (NSString *)Cooler{
    return @"格力";
}
@end
