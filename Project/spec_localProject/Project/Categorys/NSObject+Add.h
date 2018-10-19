//
//  NSObject+Add.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/16.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Add)
/**
 模型转字典

 @param object 字典或数组
 @return 字典
 */
+ (NSDictionary *)dicFromObject:(NSObject *)object;
@end
