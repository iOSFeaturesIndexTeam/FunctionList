//
//  UIButton+Add.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/16.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "UIButton+Add.h"

@implementation UIButton (Add)
+ (UIButton *)defaultType:(UIButton *)btn{
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.];
    return btn;
}
@end
