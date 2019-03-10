//
//  LWPageControl.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/9.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "LWPageControl.h"

@implementation LWPageControl
- (instancetype)init {
    if (self = [super init] ) {
        self.backgroundColor = [UIColor clearColor];
        _currentPageIndicatorColor = [UIColor grayColor];
        _othersPageIndicatorColor = [UIColor redColor];
        _sizeForPageIndicator = CGSizeMake(5, 5);
        _itemsPadding = 4;
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);//画布透明
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    
    CGSize size = _sizeForPageIndicator;
    CGFloat x = (w - size.width * _itemsPage - (_itemsPage - 1) * _itemsPadding) / 2.;
    CGFloat y = h / 2;//绘制的原点
    for (int i = 0; i < _itemsPage; i++) {
        switch (_type) {
            case LWPageControlTypeCircle:
            {
                CGFloat originPoint = x + size.width / 2. + (size.width + _itemsPadding) * i;
                CGContextMoveToPoint(context,originPoint , y);
                CGContextAddArc(context, originPoint, y, size.width / 2., 0, M_PI * 2, NO);
                //填充颜色
                CGContextSetFillColorWithColor(context, _currentPage == i ? _currentPageIndicatorColor.CGColor: _othersPageIndicatorColor.CGColor);
                //关闭绘制路径
                CGContextDrawPath(context, kCGPathFill);
            }
                break;
            case LWPageControlTypeSquare:
            {
                CGRect frame = CGRectMake(x + i * (size.width + _itemsPadding),
                                          y - size.height / 2,
                                          size.width,
                                          size.height);
                CGContextSetFillColorWithColor(context, i == _currentPage ? _currentPageIndicatorColor.CGColor : _othersPageIndicatorColor.CGColor);
                CGContextStrokeRect(context,frame);
                CGContextFillRect(context, frame);
            }
                break;
            default:
                break;
        }
    }
    
    CGContextStrokePath(context);
}
#pragma mark - setter
- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    [self setNeedsDisplay];
}

- (void)setItemsPage:(NSInteger)itemsPage{
    _itemsPage = itemsPage;
    [self setNeedsDisplay];
}
@end
