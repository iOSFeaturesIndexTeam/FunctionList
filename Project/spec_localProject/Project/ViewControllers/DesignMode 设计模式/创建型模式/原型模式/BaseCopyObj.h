//
//  BaseCopyObj.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCopyObj : NSObject<NSCopying,NSMutableCopying>

- (void)copyOperationWithObj:(id)obj;

@end
