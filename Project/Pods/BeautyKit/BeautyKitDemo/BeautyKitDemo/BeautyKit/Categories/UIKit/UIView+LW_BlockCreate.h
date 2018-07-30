//
//  UIView+LW_BlockCreate.h
//  MVC
//
//  Created by Little.Daddly on 2017/6/25.
//  Copyright © 2017年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LW_BlockCreate)

+(instancetype)lw_createAddToView:(__kindof UIView*)superView;
+(instancetype)lw_createView:(void(^)(__kindof UIView *))blockConfig;
@end
