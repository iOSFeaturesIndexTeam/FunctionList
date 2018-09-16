//
//  Student.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "Student.h"

@implementation Student
- (void)copyOperationWithObj:(Student *)obj {
    obj.name = self.name;
    obj.studentId = self.studentId;
}

@end
