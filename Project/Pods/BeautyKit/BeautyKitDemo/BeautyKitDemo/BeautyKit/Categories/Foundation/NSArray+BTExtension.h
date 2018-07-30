//
//  NSArray+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/4.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BTExtension)

/**
 数据是否为空
 */
- (BOOL)union_isEmpty;

/**
 安全读取数据
 */
- (id)union_safeObjectAtIndex:(NSUInteger)index;

/**
 根据元素依次倒序输出
 */
- (NSArray *)union_reversely;

/**
 排序
 大小写敏感
 */
- (NSArray *)union_sort;
- (NSArray *)union_sort:(id(^)(id obj))handler;
- (NSArray *)union_sortReversely;

/**
 排序
 大小写不敏感
 */
- (NSArray *)union_sortCaseInsensitive;

/**
 集合
 */
- (NSArray *)union_union:(NSArray *)anArray;
- (NSArray *)union_intersection:(NSArray *)anArray;
- (NSArray *)union_difference:(NSArray *)anArray;

/**
 返回前'count'个数据
 */
- (NSArray *)union_first:(NSInteger)count;

/**
 根据条件取数据
 */
- (NSArray *)union_takeWhile:(BOOL(^)(id obj))callback;

/**
 去除相同的元素,并获取一个唯一的数据数据
 */
- (NSArray *)union_unique;

/**
 根据条件返回值
 */
- (NSArray *)union_filter:(BOOL(^)(id obj, NSInteger index))handler;
- (NSArray *)union_map:(id(^)(id obj, NSInteger index))handler;

/**
 最小值
 */
- (id(^)(id))union_min;

/**
 最大值
 */
- (id(^)(id))union_max;

/**
 分割
 */
- (NSArray *(^)(NSUInteger start, NSUInteger length))union_slice;

/**
 最后一个数
 */
- (NSArray *(^)(NSUInteger))union_last;

/**
 归纳
 */
- (id(^)(id (^)(id memo, id obj)))union_reduce;

/**
 返回这个数组的第二个数据
 */
@property (nonatomic,readonly) id secondObject;

/**
 返回这个数组的第三个数组
 */
@property (nonatomic,readonly) id thirdObject;

@end
