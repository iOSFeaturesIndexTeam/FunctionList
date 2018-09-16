//
//  BaseCopyObj.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BaseCopyObj.h"

@implementation BaseCopyObj
- (id)copyWithZone:(nullable NSZone *)zone{
    BaseCopyObj *obj = [[self class] allocWithZone:zone];
    [self copyOperationWithObj:obj];
    return obj;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone{
    BaseCopyObj *obj = [[self class] allocWithZone:zone];
    [self copyOperationWithObj:obj];
    return obj;
}
- (void)copyOperationWithObj:(id)obj{
    
}
@end
