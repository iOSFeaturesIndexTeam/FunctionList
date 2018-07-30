//
//  NSDictionary+Encrypt.h
//  BeautyKitDemo
//
//  Created by Quincy Yan on 2017/9/6.
//  Copyright © 2017年 Beauty,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Encrypt)

/**
 对入参进行算法加密
 */
+ (NSString *)union_encryptParam:(NSDictionary *)param encryptKey:(NSString *)encryptKey;

@end
