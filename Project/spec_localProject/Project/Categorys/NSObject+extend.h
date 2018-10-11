//
//  NSObject+extend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/11.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (extend)
/** 模型转字典 */
+ (NSDictionary *)dicFromObject:(NSObject *)object;
@end
