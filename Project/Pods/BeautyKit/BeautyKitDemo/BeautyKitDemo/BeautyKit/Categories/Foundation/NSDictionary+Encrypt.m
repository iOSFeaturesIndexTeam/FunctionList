//
//  NSDictionary+Encrypt.m
//  BeautyKitDemo
//
//  Created by Quincy Yan on 2017/9/6.
//  Copyright © 2017年 Beauty,Inc. All rights reserved.
//

#import "NSDictionary+Encrypt.h"
#import "NSDictionary+BTExtension.h"
#import "NSString+BTExtension.h"

@implementation NSDictionary (Encrypt)

+ (NSString *)union_encryptParam:(NSDictionary *)param encryptKey:(NSString *)encryptKey {
    if (param.allKeys.count == 0) {
        return @"";
    }
    
    //加密前, 先将入参字典转为字符串
    NSString *strBeforeEncrypt = [param union_dictSort];
    
    //UrlEncode转换
    NSString *strAfterUrlEncode = [strBeforeEncrypt union_urlEncoding];
    
    //HmacSHA256及base64编码
    NSString *strAfterHmacSHA256 = [strAfterUrlEncode union_hmacsha256:encryptKey];
    
    //得到的结果再进行Encode转换,得到加密后的签名
    NSString * strAfterEncrypt = [strAfterHmacSHA256 union_urlEncoding];
    
    return strAfterEncrypt;
}

@end
