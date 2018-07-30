//
//  NSArray+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/4.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "NSArray+BTExtension.h"

@implementation NSArray (BTExtension)

- (BOOL)union_isEmpty {
    return (self.count == 0);
}

- (id)union_safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count){
        id object = [self objectAtIndex:index];
        if ([object isKindOfClass:[NSNull class]])
            return nil;
        return object;
    }
    return nil;
}

- (NSArray *)union_reversely {
    if (self.count <= 1) {
        return self;
    }
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)union_sort {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}

- (NSArray *)union_sort:(id (^)(id))handler {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [handler(obj1) compare:handler(obj2)];
    }];
}

- (NSArray *)union_sortReversely {
    return [[self union_sort] union_reversely];
}

- (NSArray *)union_sortCaseInsensitive {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 caseInsensitiveCompare:obj2];
    }];
}

- (NSArray *)union_union:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 unionOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *)union_intersection:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 intersectOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *)union_difference:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    [set1 minusOrderedSet:set2];
    return set1.array.copy;
}

- (NSArray *)union_first:(NSInteger)count {
    __block NSMutableArray *firsts = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        *stop = !(idx < count);
        if (!(*stop)){
            [firsts addObject:obj];
        }
    }];
    return firsts;
}

- (NSArray *)union_takeWhile:(BOOL (^)(id))handler {
    __block NSMutableArray *take = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        *stop = !handler(obj);
        if (!(*stop)){
            [take addObject:obj];
        }
    }];
    return take;
}

- (NSArray *)union_unique:(id (^)(id))handler {
    __block NSMutableDictionary *uniques = [[NSMutableDictionary alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([uniques objectForKey:handler(obj)] == nil){
            [uniques setValue:obj forKey:handler(obj)];
        }
    }];
    return [uniques allValues];
}

- (NSArray *)union_unique {
    return [[self union_unique:^id(id obj) {
        return obj;
    }] union_sort];
}

- (NSArray *)union_filter:(BOOL (^)(id, NSInteger))handler {
    __block NSMutableArray *arrays = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (handler(obj,idx)) {
            [arrays addObject:obj];
        }
    }];
    return arrays;
}

- (NSArray *)union_map:(id (^)(id, NSInteger))handler {
    __block NSMutableArray *arrays = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        id result = handler(obj,idx);
        if (result != nil) {
            [arrays addObject:result];
        }
    }];
    return arrays;
}

- (id (^)(id))union_min {
    return ^(NSInteger (^block)(id o)) {
        NSInteger value = NSIntegerMax;
        id keeper = nil;
        for (id o in self) {
            NSInteger ov = block(o);
            if (ov < value) {
                value = ov;
                keeper = o;
            }
        }
        return keeper;
    };
}

- (id (^)(id))union_max {
    return ^(NSInteger (^block)(id o)) {
        NSInteger value = NSIntegerMin;
        id keeper = nil;
        for (id o in self) {
            NSInteger ov = block(o);
            if (ov > value) {
                value = ov;
                keeper = o;
            }
        }
        return keeper;
    };
}

- (NSArray *(^)(NSUInteger, NSUInteger))union_slice {
    return ^id(NSUInteger start, NSUInteger length) {
        NSUInteger const N = self.count;
        
        if (N == 0)
            return self;
        
        if (start > N - 1) start = N - 1;
        if (start + length > N) length = N - start;
        
        return [self subarrayWithRange:NSMakeRange(start, length)];
    };
}

- (NSArray *(^)(NSUInteger))union_last {
    return ^(NSUInteger num) {
        return self.union_slice(self.count - num, num);
    };
}

- (id (^)(id (^)(id, id)))union_reduce {
    return ^(id (^block)(id, id)) {
        id memo = self.firstObject;
        for (id obj in self.union_last(self.count - 1))
            memo = block(memo, obj);
        return memo;
    };
}

- (id)secondObject {
    return [self union_safeObjectAtIndex:1];
}

- (id)thirdObject {
    return [self union_safeObjectAtIndex:2];
}

@end
