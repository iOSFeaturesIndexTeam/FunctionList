//  UIScrollView+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "UIScrollView+BTExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (BTExtension)

- (void)setUnion_insetT:(CGFloat)union_insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = union_insetT;
    self.contentInset = inset;
}

- (CGFloat)union_insetT {
    return self.contentInset.top;
}

- (void)setUnion_insetB:(CGFloat)union_insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = union_insetB;
    self.contentInset = inset;
}

- (CGFloat)union_insetB {
    return self.contentInset.bottom;
}

- (void)setUnion_insetL:(CGFloat)union_insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = union_insetL;
    self.contentInset = inset;
}

- (CGFloat)union_insetL {
    return self.contentInset.left;
}

- (void)setUnion_insetR:(CGFloat)union_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = union_insetR;
    self.contentInset = inset;
}

- (CGFloat)union_insetR {
    return self.contentInset.right;
}

- (void)setUnion_offsetX:(CGFloat)union_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = union_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)union_offsetX {
    return self.contentOffset.x;
}

- (void)setUnion_offsetY:(CGFloat)union_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = union_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)union_offsetY {
    return self.contentOffset.y;
}

- (void)setUnion_contentW:(CGFloat)union_contentW {
    CGSize size = self.contentSize;
    size.width = union_contentW;
    self.contentSize = size;
}

- (CGFloat)union_contentW {
    return self.contentSize.width;
}

- (void)setUnion_contentH:(CGFloat)union_contentH {
    CGSize size = self.contentSize;
    size.height = union_contentH;
    self.contentSize = size;
}

- (CGFloat)union_contentH {
    return self.contentSize.height;
}
@end
