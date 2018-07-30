//
//  NSData+BGExtension.m
//  BeautyKitDemo
//
//  Created by Little.Daddly on 2018/6/17.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import "NSData+BGExtension.h"
#import "BeautyKitMacro.h"
@implementation NSData (BGExtension)
+ (NSDictionary *)union_transformJSONData:(NSData *)JSONData
{
    NSError *error = nil;
    NSDictionary * retValue = [NSJSONSerialization JSONObjectWithData:JSONData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
    if (error)
    {
        KCLog(@"%@",error);
    }
    
    return retValue;
}
@end
