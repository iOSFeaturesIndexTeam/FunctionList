//
//  BTButton.h
//  BTkit
//
//  Created by BeautyHZ on 2017/8/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTButton : UIButton

/** 图片位置 */
@property (nonatomic, assign) CGRect imgRect;

/** 标题位置 */
@property (nonatomic, assign) CGRect titleRect;

/**
 设置按钮标题和图片的位置
 */
- (void)setTitleRect:(CGRect)titleRect imgRect:(CGRect)imgRect;

@end
