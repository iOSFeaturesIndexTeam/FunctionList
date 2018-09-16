//
//  Class.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
- (void)copyOperationWithObj:(ClassModel *)obj {
    obj.className = self.className;
    obj.students = [[NSArray alloc] initWithArray:self.students copyItems:YES];
}
@end
