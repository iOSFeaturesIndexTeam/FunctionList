//
//  UIView+LW_BlockCreate.m
//  MVC
//
//  Created by Little.Daddly on 2017/6/25.
//  Copyright © 2017年 Little.Daddly. All rights reserved.
//

#import "UIView+LW_BlockCreate.h"

@implementation UIView (LW_BlockCreate)
+(instancetype)lw_createAddToView:(__kindof UIView*)superView{
    return [self lw_createView:^(__kindof UIView *view) {
        [superView addSubview:view];
    }];
}
+(instancetype)lw_createView:(void(^)(__kindof UIView *))blockConfig{
    __kindof UIView *instance = [[self alloc] init];
    if(blockConfig){
        blockConfig(instance);
    }
        
    return instance;
}
@end
