//
//  Colleague.h
//  DesignModeDemo
//
//  Created by koala on 2018/4/17.
//  Copyright © 2018年 koala. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Colleague;

@protocol ColleagueDelegate <NSObject>

- (void)colleagueChoose:(Colleague *)event;

@end


@interface Colleague : NSObject

@property (nonatomic,weak) id<ColleagueDelegate> delegate;

@end
