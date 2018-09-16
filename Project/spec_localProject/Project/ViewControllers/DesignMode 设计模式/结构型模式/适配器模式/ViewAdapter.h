//
//  ViewAdapter.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "extModel.h"

typedef NS_ENUM(NSUInteger,ViewStyle) {
    ViewStyleBig,
    ViewStyleSmall,
    ViewStyleSuperBig
};

@interface ViewAdapter : NSObject

@property (nonatomic,assign) ViewStyle style;
@property (nonatomic,strong) UIView *current;

+ (instancetype)shareManager;

+ (instancetype)BigViewAdapterWithModel:(extModel *)m superView:(UIView *)superV;
+ (instancetype)SmallViewAdapterWithModel:(extModel *)m superView:(UIView *)superV;;
+ (instancetype)SuperBigViewAdapterWithModel:(extModel *)m superView:(UIView *)superV;
@end
