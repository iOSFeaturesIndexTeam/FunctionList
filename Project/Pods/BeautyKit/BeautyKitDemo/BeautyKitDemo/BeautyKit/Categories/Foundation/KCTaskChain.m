//
//  TaskChain.m
//  TaskChain
//
//  Created by dyf on 17/3/23.
//  Copyright © 2017年 wisorg. All rights reserved.
//

#import "KCTaskChain.h"

@interface KCTaskChain ()
@property (nonatomic, assign) BOOL stop;

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, copy) void(^runingTask)(void(^)(BOOL stop));
@end


@implementation KCTaskChain

- (id)init
{
    self = [super init];
    if (self) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc {
    self.runingTask = NULL;
}

- (KCTaskChain *)run:(void(^)(void(^next)(BOOL go)))task
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tasks addObject:task];
        [self flushQueue];
    });
    return self;
}

- (KCTaskChain *(^)(void(^)(void(^next)(BOOL go))))run
{
    return ^KCTaskChain *(void(^f)(void(^finish)(BOOL))){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tasks addObject:f];
            [self flushQueue];
        });
        return self;
    };
}

- (void)flushQueue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.runingTask) {
            return;
        }
        if (self.stop) {
            [_tasks removeAllObjects];
            return;
        }
        if ([_tasks count] > 0) {
            self.runingTask = _tasks[0];
            [_tasks removeObjectAtIndex:0];
            
            void (^fi)(BOOL) = ^(BOOL go) {
                self.stop = !go;
                self.runingTask = NULL;
                [self flushQueue];
            };
            _runingTask(fi);
        }
    });
}

@end
