//
//  NSData+BGExtension.h
//  BeautyKitDemo
//
//  Created by Little.Daddly on 2018/6/17.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (BGExtension)
// JSONData转成id类型
+ (NSDictionary *)union_transformJSONData:(NSData *)JSONData;
@end
