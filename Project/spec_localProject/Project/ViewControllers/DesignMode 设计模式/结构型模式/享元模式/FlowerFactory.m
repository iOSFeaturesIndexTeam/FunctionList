//
//  FlowerFactory.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "FlowerFactory.h"
@interface FlowerFactory ()
@property (nonatomic,strong) NSMutableDictionary *pools;
@end
@implementation FlowerFactory
- (Flower *)multiplexFlowerWithType:(FlowerType)type{
    if (!_pools) {
        _pools = [NSMutableDictionary dictionary];
    }
    if (![_pools valueForKey:IntToStr(type)]) {
        Flower *a = [Flower new];
        NSString *name = nil;
        switch (type) {
            case FlowerTypePeony:
                name = @"牡丹";
                break;
            case FlowerTypeChrysanthemum:
                name = @"菊花";
                break;
            default:
                break;
        }
        a.name = name;
        [_pools setValue:a forKey:IntToStr(type)];
        return a;
    } else {
        return [_pools valueForKey:IntToStr(type)];
    }
}
@end
