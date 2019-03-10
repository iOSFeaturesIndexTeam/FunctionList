//
//  LDCarousel.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/6/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDCarousel;

@protocol LDCarouselDelegate <NSObject>
/**点击图片后的操作*/
- (void)carousel:(LDCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;
@end


/** 轮播器
 */
@interface LDCarousel : UIView

/**初始化*/
+ (instancetype)initCarouselWithFrame:(CGRect)frame;
/**关闭轮播计时器，需手动调用，否则会循环引用*/
- (void)stopTimer;
/** 唤醒计时器 */
- (void)resumeTimer;
/**代理*/
@property (nonatomic, weak) id<LDCarouselDelegate> delegate;
/**图片名称或url的数组*/
@property (nonatomic, strong) NSMutableArray<NSString *> *imageList;
/**标题的数组*/
@property (nonatomic, strong) NSMutableArray<NSString *> *titleList;
/**是否无限循环轮播*/
@property (nonatomic, assign, getter=isLoop) BOOL loop;
/**自动轮播时间间隔，默认为0，0表示不开启自动轮播*/
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
/**图片的展示方式*/
@property (nonatomic, assign) UIViewContentMode imageContentMode;
/**占位图片*/
@property (nonatomic, strong) UIImage *placeholderImage;

@end
