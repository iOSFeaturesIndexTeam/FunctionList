//
//  AbstractFactory.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "AbstractFactory.h"

@implementation AbstractFactory
+ (instancetype)product {
    return nil;
}

- (void)productInfo{
    
}

- (NSString *)baseData{
    return @"不锈钢";
}

@end
