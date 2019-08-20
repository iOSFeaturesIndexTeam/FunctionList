//
//  LWRouterMsgSend.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (LWRouterMsgSend)

- (id)RTCallSelectorWithArgArray:(SEL)selector arg:(NSArray *)arg error:(NSError *__autoreleasing *)error;

FOUNDATION_EXPORT  NSArray *rt_targetBoxingArguments(va_list argList, Class cls, SEL selector, NSError *__autoreleasing *error);


// steven
FOUNDATION_EXPORT  id rt_nilObj();

@end


