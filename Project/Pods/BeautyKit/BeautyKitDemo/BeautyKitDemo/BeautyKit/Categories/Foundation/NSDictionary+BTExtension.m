//
//  NSDictionary+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/4/28.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "NSDictionary+BTExtension.h"
#import "NSArray+BTExtension.h"

@implementation NSDictionary (BTExtension)

- (BOOL)union_isEmpty {
    return self.allKeys.count == 0;
}

- (NSString *)union_dictSort {
    if (self.allKeys.count == 0) return nil;
    
    NSMutableDictionary *dic = self.mutableCopy;
    NSString *str = @"";
    for (NSString *key in [dic.allKeys union_sort]) {
        id value = dic[key];
        //字典数组转json字符串
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            if ([NSJSONSerialization isValidJSONObject:value]) {
                //options设置成0去除换行空格这些
                NSData *data=[NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                dic[key] = jsonStr;
            }
        }
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,dic[key]]];
    }
    return [str substringToIndex:str.length - 1];
}

- (NSDictionary *)union_dictAppendingParams:(NSDictionary *)params{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self];
    for (NSString *key in params.allKeys) {
        [dic setObject:[params objectForKey:key] forKey:key];
    }
    return dic;
}

+ (NSDictionary *)union_dictWithJSONString:(NSString *)string {
    NSData *resultData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * retValue = [NSJSONSerialization JSONObjectWithData:resultData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
    return retValue;
}

- (NSArray *)union_dateSort {
    NSMutableArray *array = self.allKeys.mutableCopy;
    array = (NSMutableArray *)[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        
        NSDate *date1 = [formatter dateFromString:obj1];
        NSDate *date2 = [formatter dateFromString:obj2];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    return array;
}

@end
