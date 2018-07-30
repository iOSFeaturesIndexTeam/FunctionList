//
//  UIImageView+BTExtension.h
//  BTExtension
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 BTExtension. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BTExtension)

+ (UIImageView *)union_imageViewWithImageName:(NSString *)imageName;

+ (UIImageView *)union_imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName  contentMode:(UIViewContentMode)contentMode;
    
@end
