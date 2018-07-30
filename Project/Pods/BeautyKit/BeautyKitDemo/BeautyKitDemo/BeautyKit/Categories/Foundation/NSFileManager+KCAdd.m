//
//  NSFileManager+KCAdd.m
//  KidsCamera
//
//  Created by 王文震 on 2018/5/7.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import "NSFileManager+KCAdd.h"
@implementation NSFileManager (KCAdd)
- (NSArray *)sortSubpathsOfDirectoryAtPath:(NSString *)path{
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSArray *sortImgs = [files sortedArrayUsingComparator:^NSComparisonResult(NSString *path1, NSString *path2) {
        return (NSComparisonResult)[path1 compare:path2 options:NSNumericSearch];
    }];
    return sortImgs;
}
@end
