//
//  NSDictionary+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BTExtension)

/** 
 是否空字典 
 */
- (BOOL)union_isEmpty;

/**
 对字典中的键值进行‘类URL’排序,字典中的数组字典转json字符串处理
 */
- (NSString *)union_dictSort;

/**
 添加另外的字典的数据
 */
- (NSDictionary *)union_dictAppendingParams:(NSDictionary *)params;

/**
 根据文件名获取字典数据
 */
+ (NSDictionary *)union_dictWithJSONString:(NSString *)string;

/**
 转换成日期进行排序
 */
- (NSArray *)union_dateSort;

@end
