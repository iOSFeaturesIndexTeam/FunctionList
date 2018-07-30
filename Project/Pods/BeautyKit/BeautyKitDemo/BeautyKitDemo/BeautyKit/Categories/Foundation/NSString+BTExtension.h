//
//  NSString+BTExtension.h
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (BTExtension)

#pragma mark - 字符串验证相关

- (BOOL)union_isExist;
- (BOOL)union_isEmpty; //这里注意nil/null是走不了这个方法的,判断字符串是否存在最好用union_isExist方法
- (BOOL)union_isEmail;
- (BOOL)union_isValidPhone;
- (BOOL)union_isAllNumber;
- (BOOL)union_isAllChinese;
- (BOOL)union_isAllEnglish;
- (BOOL)union_includeChinese;
- (BOOL)union_contains:(NSString *)string;

/* 手机号验证 */
+ (BOOL)union_isValidateMobile:(NSString *)strMobile;

/**
 是否字符串包含emoji表情
 */
+ (BOOL)union_stringContainsEmoji:(NSString *)string;

/**
 身份证号码验证
 */
+ (BOOL)union_stringIsValidateIdentityCard:(NSString *)identityCard;

/**
 邮箱验证
 */
+ (BOOL)union_stringIsValidateEmail:(NSString *)strEmail;

/**
 删除空格
 */
- (NSString *)union_trimWhitespace;

/** 
 删除空格和换行
 */
- (NSString *)union_trimWhiteSpaceAndEmptyLine;

/** 
 隐藏敏感信息
 */
+ (NSString *)union_hidePhoneAndEmail:(NSString *)str;

/** 
 获取一个随机的字符串
 */
- (NSString *)union_stringRandomly;

/**
 转换拼音
 */
- (NSString *)union_transformToPinyin;

/**
 用 * 代替字符串
 隐藏手机号与邮箱
 */
- (NSString *)union_replacePhoneAndEmail;

/**
 对一些敏感的字符串进行隐藏
 手机号 & 邮箱
 */
- (NSString *)union_securePhoneAndEmail;

/**
 对后台传过来的URL进行处理
 去除空格、中文编码
 */
- (NSURL *)union_handleURL;

#pragma mark - 字符串尺寸相关

/** 
 获取文本尺寸
 */
- (CGSize)union_stringSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;;
- (CGSize)union_stringSizeWithFontSize:(NSUInteger)font maxSize:(CGSize)maxSize;
- (CGFloat)union_stringHeightWithFontSize:(NSUInteger)fontSize maxSize:(CGSize)size;
- (CGFloat)union_stringWidthWithFontSize:(NSUInteger)fontSize maxSize:(CGSize)size;
- (CGSize)union_stringSizeWithAttribute:(NSDictionary *)attribute maxSize:(CGSize)maxSize;;

#pragma mark - 加密相关

- (NSString *)union_md5;
- (NSString *)union_sha256;
- (NSString *)union_hmacsha256:(NSString *)key;
- (NSString *)union_urlEncoding;
+ (NSString*)getCurrentTimes;
@end
