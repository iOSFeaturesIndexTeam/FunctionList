//
//  NSData+Extend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/1.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extend)
/** jsonData转成字典*/
+ (NSDictionary *)jsonDataToDic:(NSData *)jsonData;
@end
