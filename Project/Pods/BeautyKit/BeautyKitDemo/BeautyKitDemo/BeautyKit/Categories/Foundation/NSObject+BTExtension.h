//
//  NSObject+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/8.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BTExtension)

/**
 获取类中的所有参数
 */
+ (NSArray *)union_properties;

/**
 获取类中的一个属性的值
 */
- (id)union_valueOfKey:(NSString *)key;

/**
 完全复制一个类
 */
- (id)union_copy;

/**
 搜索一个类中是否有该属性名
 */
+ (BOOL)union_searchClass:(Class)aClass hasProperty:(NSString *)property;

/**
 对一个对象进行赋值
 */
- (id)union_assignValues:(NSDictionary *)valuesParams;

/**
 根据名称初始化一个对象
 */
+ (id)union_initWithClassName:(NSString *)aClass params:(NSDictionary *)params;

/**
 拨打电话
 */
+ (void)union_makeCall:(NSString *)phoneNumber;

/**
 打开一个网页链接
 */
+ (void)union_openURL:(NSString *)URL;

/**
 跳转系统协议
 */
+ (void)union_openSystemURL:(NSString *)URL;

/**
 获取当前设备型号
 */
+ (NSString *)union_device;

/**
 获取对外版本号
 */
+ (NSString *)union_shortVersion;

/**
 获取包名
 */
+ (NSString *)union_bundleIdentifier;

@end
