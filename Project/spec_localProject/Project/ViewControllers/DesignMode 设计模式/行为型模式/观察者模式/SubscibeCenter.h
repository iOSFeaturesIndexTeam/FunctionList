//
//  SubscibeCenter.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SubscibeProtocol.h"

@interface SubscibeCenter : NSObject

+ (void)addUser:(id <SubscibeProtocol>)user withNumber:(NSString *)number;

+ (void)removeUser:(id <SubscibeProtocol>)user withNumber:(NSString *)number;

+ (void)sendMessage:(NSString *)message withNumber:(NSString *)number;

@end
