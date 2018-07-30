//
//  NSDictionary+MHJsonHelper.m
//  MissionHall
//
//  Created by wl on 2017/9/27.
//  Copyright © 2017年 xinhui wang. All rights reserved.
//

#import "NSDictionary+MHJsonHelper.h"

@implementation NSDictionary (MHJsonHelper)

- (NSString *)debugDescription {
    
    NSString *debugDescription;
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        debugDescription = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return debugDescription?:self.description;
}

@end

@implementation NSArray (MHJsonHelper)

- (NSString *)debugDescription {
    
    NSString *debugDescription;
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        debugDescription = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return debugDescription?:self.description;
}

@end
