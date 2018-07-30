//
//  NSString+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "NSString+BTExtension.h"
#import "NSArray+BTExtension.h"
#import "NSDictionary+BTExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (BTExtension)

- (BOOL)union_isExist {
    return self.length != 0 && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0;
}

- (BOOL)union_isEmpty {    
    return self.length == 0 || [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

- (BOOL)union_isValidPhone {
    NSString *mobile = self;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        } else{
            return NO;
        }
    }
}

- (BOOL)union_contains:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

- (BOOL)union_isAllNumber {
    unichar c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)union_isEmail {
    NSString *emailRegex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (BOOL)union_stringIsValidateEmail:(NSString *)strEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}

- (BOOL)union_isAllChinese {
    NSString *chineseRegex = @"^[\\u4E00-\\u9FA5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chineseRegex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)union_includeChinese {
    for(int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

- (BOOL)union_isAllEnglish {
    if (self.length == 0) return NO;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return count == self.length;
}

+ (BOOL)union_isValidateMobile:(NSString *)strMobile {
    NSString *mobile = strMobile;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    } else {
        NSString * NUM =  @"^1[3|4|5|6|7|8|9][0-9]\\d{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
        BOOL isMatch = [pred evaluateWithObject:mobile];
        return isMatch;
    }
}

+ (BOOL)union_stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

+ (BOOL)union_stringIsValidateIdentityCard:(NSString *)identityCard {
    BOOL flag;
    
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
}

- (NSString *)union_trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)union_trimWhiteSpaceAndEmptyLine {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)union_stringRandomly {
    return [NSString stringWithFormat:@"%c",arc4random_uniform(26) + 'a'];
}

- (CGSize)union_stringSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                           attributes:attribute
                              context:nil].size;
}

- (CGSize)union_stringSizeWithAttribute:(NSDictionary *)attribute maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                           attributes:attribute
                              context:nil].size;
}

- (CGSize)union_stringSizeWithFontSize:(NSUInteger)fontSize maxSize:(CGSize)maxSize {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                           attributes:attribute
                              context:nil].size;
}

- (CGFloat)union_stringHeightWithFontSize:(NSUInteger)fontSize maxSize:(CGSize)size {
    return [self union_stringSizeWithFontSize:fontSize maxSize:size].height;
}

- (CGFloat)union_stringWidthWithFontSize:(NSUInteger)fontSize maxSize:(CGSize)size {
    return [self union_stringSizeWithFontSize:fontSize maxSize:size].width + 1;
}

+ (NSString *)union_hexString:(uint8_t *)bytes withLength:(NSInteger)len {
    NSMutableString *output = [NSMutableString stringWithCapacity:len * 2];
    for(int i = 0; i < len; i++) {
        [output appendFormat:@"%02x", bytes[i]];
    }
    return [output copy];
}

- (NSString *)union_md5 {
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    return [NSString union_hexString:result withLength:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)union_sha256 {
    const char *str = [self UTF8String];
    uint8_t result[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (uint32_t)strlen(str), result);
    return [NSString union_hexString:result withLength:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)union_hmacsha256:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return [HMAC base64EncodedStringWithOptions:0];
}

- (NSString *)union_urlEncoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8 ));
}

+ (NSString *)union_hidePhoneAndEmail:(NSString *)str {
    if (![str.class isSubclassOfClass:NSString.class]) {
        str = [NSString stringWithFormat:@"%@",str];
    }
    if (str.length <= 0) {
        return str;
    }
    NSString *strPad = @"**************************************";
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([identityCardPredicate evaluateWithObject:str]) {
        //        return @"identityCard";
    }
    
    NSString *phoneRegex = @"^[1][0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ([phoneTest evaluateWithObject:str]) {
        return  [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:[strPad substringWithRange:NSMakeRange(0,4)]];
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:str]) {
        NSArray * arr=[str componentsSeparatedByString:@"@"];
        NSString * firstStr=arr[0];
        
        if (firstStr.length >= 6) {
            return [NSString stringWithFormat:@"%@@%@",[str stringByReplacingCharactersInRange:NSMakeRange(3, str.length-3) withString:@"****"],[arr objectAtIndex:1]];
        }
        
        if (firstStr.length < 6 && firstStr.length > 2) {
            return [NSString stringWithFormat:@"%@%@",[str stringByReplacingCharactersInRange:NSMakeRange(1, 2) withString:@"**"],[arr objectAtIndex:1]];
        }
        if (firstStr.length <= 2) {
            return [NSString stringWithFormat:@"%@%@",[str stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"],[arr objectAtIndex:1]];
        }
    }
    return str;
}

- (NSString *)union_transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    
    NSString *tempString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [tempString uppercaseString];
}

- (NSString *)union_replacePhoneAndEmail {
    if (self.length > 0) {
        NSString *strPad = @"**************************************";
        NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([identityCardPredicate evaluateWithObject:self]) {
            
        }
        
        NSString *phoneRegex = @"^[1][0-9]{10}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        if ([phoneTest evaluateWithObject:self]) {
            return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:[strPad substringWithRange:NSMakeRange(0,4)]];
        }
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:self]) {
            NSArray *arr = [self componentsSeparatedByString:@"@"];
            NSString *firstStr=arr[0];
            
            if (firstStr.length >= 6) {
                return [NSString stringWithFormat:@"%@@%@",[self stringByReplacingCharactersInRange:NSMakeRange(3, self.length - 3) withString:@"****"],[arr objectAtIndex:1]];
            }
            
            if (firstStr.length < 6 && firstStr.length > 2) {
                return [NSString stringWithFormat:@"%@%@",[self stringByReplacingCharactersInRange:NSMakeRange(1, 2) withString:@"**"],[arr objectAtIndex:1]];
            }
            
            if (firstStr.length<=2) {
                return [NSString stringWithFormat:@"%@%@",[self stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"],[arr objectAtIndex:1]];
            }
        }
    }
    return self;
}

- (NSString *)union_securePhoneAndEmail {
    if (![self union_isEmpty]) {
        NSString *phoneRegex = @"^[1][0-9]{10}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        if ([phoneTest evaluateWithObject:self]) {
            return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        
        NSString *emailRegex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:self]) {
            NSArray *mailArrays = [self componentsSeparatedByString:@"@"];
            NSString *firstPart = [mailArrays firstObject];
            if (firstPart.length > 4) {
                // 前大于4位字符，显示前三位和最后一位中间统一四个星（****）代替
                return  [NSString stringWithFormat:@"%@****%@@%@",[firstPart substringToIndex:3],[firstPart substringFromIndex:firstPart.length-1],[mailArrays objectAtIndex:1]];
            }
            else {
                // 前小于等于4位字符，显示首字母后接四个星（****）
                return [NSString stringWithFormat:@"%@****@%@",[firstPart substringToIndex:1],[mailArrays objectAtIndex:1]];
            }
        }
    }
    return self;
}

- (NSURL *)union_handleURL {
    NSString *urlStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //decode
    NSString *originalUrlStr = [urlStr stringByRemovingPercentEncoding];
    //encode
    NSString *encodeStr = [originalUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:encodeStr];
}

+ (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}
@end
