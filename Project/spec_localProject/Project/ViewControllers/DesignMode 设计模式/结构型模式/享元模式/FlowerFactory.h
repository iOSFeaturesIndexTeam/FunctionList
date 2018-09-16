//
//  FlowerFactory.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flower.h"
typedef NS_ENUM(NSUInteger,FlowerType) {
    FlowerTypePeony,
    FlowerTypeChrysanthemum
};

@interface FlowerFactory : NSObject
- (Flower *)multiplexFlowerWithType:(FlowerType)type;
@end
