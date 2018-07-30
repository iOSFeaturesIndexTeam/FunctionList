//
//  TaskChain.h
//  TaskChain
//
//  Created by dyf on 17/3/23.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCTaskChain : NSObject
/*
 提供两种链式方法调用：
 参考reactiveCocoa，中括号式方法调用
 参考masory点号式方法调用
 
 对于next这个block必须调用，如果子任务相中断任务链则执行next(NO)
 */

- (KCTaskChain *)run:(void(^)(void(^next)(BOOL go)))task;
- (KCTaskChain *(^)(void(^)(void(^next)(BOOL go))))run;

@end
