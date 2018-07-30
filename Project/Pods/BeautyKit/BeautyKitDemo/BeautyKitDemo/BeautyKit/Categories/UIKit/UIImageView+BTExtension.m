//
//  UIImageView+BTExtension.m
//  BTExtension
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 BTExtension. All rights reserved.
//

#import "UIImageView+BTExtension.h"
#import "UIView+BTExtension.h"

@implementation UIImageView (BTExtension)

+ (UIImageView *)union_imageViewWithImageName:(NSString *)imageName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (UIImageView *)union_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName contentMode:(UIViewContentMode)contentMode {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.contentMode = contentMode;
    imgView.image = [UIImage imageNamed:imageName];
    return imgView;
}

@end
