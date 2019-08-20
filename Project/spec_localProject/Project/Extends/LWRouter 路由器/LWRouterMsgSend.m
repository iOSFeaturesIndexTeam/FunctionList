//
//  LWRouterMsgSend.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/19.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "LWRouterMsgSend.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIApplication.h>
#endif


#pragma mark : rt_nilObject

@interface rt_pointer : NSObject

@property (nonatomic) void *pointer;

@end

@implementation rt_pointer

@end

@interface rt_nilObject : NSObject

@end

@implementation rt_nilObject

@end

#pragma mark : static

static NSLock *_vkMethodSignatureLock;
static NSMutableDictionary *_vkMethodSignatureCache;
static rt_nilObject *vknilPointer = nil;


static rt_nilObject *temp_vknilPointer = nil;


id rt_nilObj(){
    
    if (!temp_vknilPointer) {
        temp_vknilPointer = [[rt_nilObject alloc] init];
    }
    return temp_vknilPointer;
}


static NSString *rt_extractStructName(NSString *typeEncodeString){
    
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    __block int firstVaildIndex = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        char c = [typeEncodeString characterAtIndex:idx];
        if (c=='{'||c=='_') {
            firstVaildIndex++;
        }else{
            *stop = YES;
        }
    }];
    return [typeString substringFromIndex:firstVaildIndex];
}

static NSString *rt_selectorName(SEL selector){
    const char *selNameCstr = sel_getName(selector);
    NSString *selName = [[NSString alloc]initWithUTF8String:selNameCstr];
    return selName;
}

static NSMethodSignature *rt_getMethodSignature(Class cls, SEL selector){
    
    if(!_vkMethodSignatureLock)
        _vkMethodSignatureLock = [[NSLock alloc] init];
    [_vkMethodSignatureLock lock];
    
    if (!_vkMethodSignatureCache) {
        _vkMethodSignatureCache = [[NSMutableDictionary alloc]init];
    }
    if (!_vkMethodSignatureCache[cls]) {
        _vkMethodSignatureCache[(id<NSCopying>)cls] =[[NSMutableDictionary alloc]init];
    }
    NSString *selName = rt_selectorName(selector);
    NSMethodSignature *methodSignature = _vkMethodSignatureCache[cls][selName];
    if (!methodSignature) {
        methodSignature = [cls instanceMethodSignatureForSelector:selector];
        if (methodSignature) {
            _vkMethodSignatureCache[cls][selName] = methodSignature;
        }else
        {
            methodSignature = [cls methodSignatureForSelector:selector];
            if (methodSignature) {
                _vkMethodSignatureCache[cls][selName] = methodSignature;
            }
        }
    }
    [_vkMethodSignatureLock unlock];
    return methodSignature;
}

static void rt_generateError(NSString *errorInfo, NSError **error){
    if (error) {
        *error = [NSError errorWithDomain:errorInfo code:0 userInfo:nil];
    }
}

static id rt_targetCallSelectorWithArgumentError(id target, SEL selector, NSArray *argsArr, NSError *__autoreleasing *error){
    
    
    Class cls = [target class];
    NSMethodSignature *methodSignature = rt_getMethodSignature(cls, selector);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    //
    if([methodSignature numberOfArguments] -2 != argsArr.count)
    {
        NSString* errorStr = [NSString stringWithFormat:@"参数与方法不匹配 (%@)", NSStringFromSelector(selector)];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    
    for (int i = 2; i< [methodSignature numberOfArguments]; i++) {
//        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        id valObj = argsArr[i-2];
        if ([valObj isKindOfClass:[rt_nilObject class]]) {
            [invocation setArgument:&vknilPointer atIndex:i];
        }else{
            [invocation setArgument:&valObj atIndex:i];
        }
    }
    
    [invocation invoke];

    return nil;
};

NSArray *rt_targetBoxingArguments(va_list argList, Class cls, SEL selector, NSError *__autoreleasing *error){
    
    Class c = [cls class];
    NSMethodSignature *methodSignature = rt_getMethodSignature(c, selector);
    NSString *selName = rt_selectorName(selector);
    
    if (!methodSignature) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized selector (%@)", selName];
        rt_generateError(errorStr,error);
        return nil;
    }
    
    
    
    NSMutableArray *argumentsBoxingArray = [[NSMutableArray alloc]init];
    
    for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
#define RT_BOXING_ARG_CASE(_typeString, _type)\
case _typeString: {\
_type value = va_arg(argList, _type);\
[argumentsBoxingArray addObject:@(value)];\
break; \
}\

                RT_BOXING_ARG_CASE('c', int)
                RT_BOXING_ARG_CASE('C', int)
                RT_BOXING_ARG_CASE('s', int)
                RT_BOXING_ARG_CASE('S', int)
                RT_BOXING_ARG_CASE('i', int)
                RT_BOXING_ARG_CASE('I', unsigned int)
                RT_BOXING_ARG_CASE('l', long)
                RT_BOXING_ARG_CASE('L', unsigned long)
                RT_BOXING_ARG_CASE('q', long long)
                RT_BOXING_ARG_CASE('Q', unsigned long long)
                RT_BOXING_ARG_CASE('f', double)
                RT_BOXING_ARG_CASE('d', double)
                RT_BOXING_ARG_CASE('B', int)
                
            case ':': {
                SEL value = va_arg(argList, SEL);
                NSString *selValueName = NSStringFromSelector(value);
                [argumentsBoxingArray addObject:selValueName];
            }
                break;
            case '{': {
                NSString *typeString = rt_extractStructName([NSString stringWithUTF8String:argumentType]);
                
#define rt_FWD_ARG_STRUCT(_type, _methodName) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
_type val = va_arg(argList, _type);\
NSValue* value = [NSValue _methodName:val];\
[argumentsBoxingArray addObject:value];  \
break; \
}
                rt_FWD_ARG_STRUCT(CGRect, valueWithCGRect)
                rt_FWD_ARG_STRUCT(CGPoint, valueWithCGPoint)
                rt_FWD_ARG_STRUCT(CGSize, valueWithCGSize)
                rt_FWD_ARG_STRUCT(NSRange, valueWithRange)
                rt_FWD_ARG_STRUCT(CGAffineTransform, valueWithCGAffineTransform)
                rt_FWD_ARG_STRUCT(UIEdgeInsets, valueWithUIEdgeInsets)
                rt_FWD_ARG_STRUCT(UIOffset, valueWithUIOffset)
                rt_FWD_ARG_STRUCT(CGVector, valueWithCGVector)
            }
                break;
            case '*':{
                rt_generateError(@"unsupported char* argumenst",error);
                return nil;
            }
                break;
            case '^': {
                void *value = va_arg(argList, void**);
                rt_pointer *pointerObj = [[rt_pointer alloc]init];
                pointerObj.pointer = value;
                [argumentsBoxingArray addObject:pointerObj];
            }
                break;
            case '#': {
                Class value = va_arg(argList, Class);
                [argumentsBoxingArray addObject:(id)value];
                //                rt_generateError(@"unsupported class argumenst",error);
                //                return nil;
            }
                break;
            case '@':{
                id value = va_arg(argList, id);
                if (value) {
                    [argumentsBoxingArray addObject:value];
                }else{
                    [argumentsBoxingArray addObject:[rt_nilObject new]];
                }
            }
                break;
            default: {
                rt_generateError(@"unsupported argumenst",error);
                return nil;
            }
        }
    }
    return [argumentsBoxingArray copy];
}

@implementation NSObject (LWRouterMsgSend)

- (id)RTCallSelectorWithArgArray:(SEL)selector arg:(NSArray *)arg error:(NSError *__autoreleasing *)error{
    
    
    return rt_targetCallSelectorWithArgumentError(self, selector, arg, error);
}

@end


