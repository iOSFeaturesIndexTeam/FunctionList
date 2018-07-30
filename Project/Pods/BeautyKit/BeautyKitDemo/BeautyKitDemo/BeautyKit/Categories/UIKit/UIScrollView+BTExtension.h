//  UIScrollView+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (BTExtension)
    
@property (assign, nonatomic) CGFloat union_insetT;
@property (assign, nonatomic) CGFloat union_insetB;
@property (assign, nonatomic) CGFloat union_insetL;
@property (assign, nonatomic) CGFloat union_insetR;

@property (assign, nonatomic) CGFloat union_offsetX;
@property (assign, nonatomic) CGFloat union_offsetY;

@property (assign, nonatomic) CGFloat union_contentW;
@property (assign, nonatomic) CGFloat union_contentH;
    
@end
