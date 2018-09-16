//
//  AbstractFactory.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractFactory : NSObject
/** 电子组件，用来生产 目标设备*/
@property (nonatomic,copy) NSString *baseData;
+ (instancetype)product;
- (void)productInfo;
@end
