//
//  Student.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/9/16.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "BaseCopyObj.h"

@interface Student : BaseCopyObj
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *studentId;
@end
