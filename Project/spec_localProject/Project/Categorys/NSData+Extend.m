//
//  NSData+Extend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/1.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "NSData+Extend.h"

@implementation NSData (Extend)
+ (NSDictionary *)jsonDataToDic:(NSData *)jsonData{
    NSError *error = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        KCLog(@"jsonDataToDic ERROR - %@",error);
    }
    return res;
}
@end
