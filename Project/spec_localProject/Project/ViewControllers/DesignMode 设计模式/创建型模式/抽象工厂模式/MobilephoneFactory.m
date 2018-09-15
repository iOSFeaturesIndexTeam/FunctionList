//
//  MobilephoneFactory.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "MobilephoneFactory.h"

@implementation MobilephoneFactory
+ (instancetype)product{
    return [MobilephoneFactory new];
}

- (void)productInfo{
    KCLog(@"生产手机 外壳%@，%@",self.baseData,self.physicalCard);
}

- (NSString *)physicalCard{
    return @"中国移动";
}
@end
