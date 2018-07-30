//
//  NSMutableArray+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/31.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "NSMutableArray+BTExtension.h"

@implementation NSMutableArray (BTExtension)

- (BOOL)union_isEmpty {
    return self.count == 0;
}

- (void)union_safeAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

- (void)union_safeInsertObject:(id)object atIndex:(NSUInteger)index {
    if (object) {
        [self insertObject:object atIndex:index];
    }
}
@end
