//
//  NSMutableArray+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/31.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (BTExtension)

/** 
 是否空数组 
 */
- (BOOL)union_isEmpty;

/** 
 可变数组加数据 
 */
- (void)union_safeAddObject:(id)object;

/** 
 可变数组插入数据 
 */
- (void)union_safeInsertObject:(id)object atIndex:(NSUInteger)index;

@end
