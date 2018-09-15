//
//  Factory.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pencil.h"
#import "BallpointPen.h"
typedef NS_ENUM(NSUInteger,PenType) {
    PenTypePencil,//铅笔
    PenTypeBallpointPen//圆珠笔
};



@interface Factory : NSObject
/** 笔杆加工 */
+ (Pen *)productPenWithType:(PenType)type;

/** 玩具加工 */
+ (instancetype)productToyWithType:(id)type;
@end
