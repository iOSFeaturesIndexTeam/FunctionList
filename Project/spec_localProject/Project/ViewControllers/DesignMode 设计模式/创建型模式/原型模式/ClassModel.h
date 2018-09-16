//
//  Class.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BaseCopyObj.h"
#import "Student.h"

@interface ClassModel : BaseCopyObj

@property (nonatomic,copy) NSString *className;
@property (nonatomic,strong) NSArray <Student *>*students;
@end
