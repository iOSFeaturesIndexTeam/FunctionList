//
//  NSFileManager+KCAdd.h
//  KidsCamera
//
//  Created by 王文震 on 2018/5/7.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (KCAdd)
/**
 沙盒文件进行排序 【获取顺序同文件路径展示】

 @param path 沙盒路径
 @return 排序数组
 */
- (NSArray *)sortSubpathsOfDirectoryAtPath:(NSString *)path;
@end
