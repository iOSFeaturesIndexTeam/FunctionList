//
//  NSObject+BTExtension.m
//  BeautyMall
//
//  Created by xueMingLuan on 2017/5/8.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "NSObject+BTExtension.h"
#import <objc/runtime.h>
#import "sys/utsname.h"
#import <UIKit/UIKit.h>

@implementation NSObject (BTExtension)

+ (NSArray *)union_properties {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *keys = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [name substringFromIndex:1];
        [keys addObject:key];
    }
    return keys;
}

- (id)union_valueOfKey:(NSString *)key {
    SEL value = NSSelectorFromString(key);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:value];
#pragma clang diagnostic pop
}

- (id)union_copy {
    NSArray *keys = [[self class] union_properties];
    id class = [[[self class] alloc] init];
    for (NSString *key in keys) {
        [class setValue:[self union_valueOfKey:key] forKey:key];
    }
    return class;
}

+ (BOOL)union_searchClass:(Class)aClass hasProperty:(NSString *)property {
    if (aClass == nil) return NO;
    if (property == nil || property.length == 0) return NO;
    
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList(aClass , &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property_t = properties[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property_t) encoding:NSUTF8StringEncoding];
        if ([key isEqualToString:property]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}

- (id)union_assignValues:(NSDictionary *)valuesParams {
    if (valuesParams.allKeys.count == 0) return self;
    for (NSString *key in valuesParams.allKeys) {
        if ([[self class] union_searchClass:[self class] hasProperty:key]) {
            [self setValue:valuesParams[key] forKey:key];
        }
    }
    return self;
}

+ (id)union_initWithClassName:(NSString *)aClass params:(NSDictionary *)params {
    if (aClass == nil || aClass.length == 0) return nil;
    
    const char *class = [aClass cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(class);
    if (!newClass) {
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, class, 0);
        objc_registerClassPair(newClass);
    }
    id instance = [[newClass alloc] init];
    return [instance union_assignValues:params];
}

+ (void)union_makeCall:(NSString *)phoneNumber {
    if (!phoneNumber || phoneNumber.length == 0) {
        return;
    }
    NSString *URLString = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    NSURL *url = [NSURL URLWithString:URLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)union_openURL:(NSString *)URL {
    if (!URL) {
        return;
    }
    if (URL && ![URL hasPrefix:@"https://"]) {
        if (![URL hasPrefix:@"http://"]) {
            URL = [NSString stringWithFormat:@"http://%@", URL];
        }
    }
    NSURL *myURL = [NSURL URLWithString:URL];
    if ([[UIApplication sharedApplication] canOpenURL:myURL]) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
            [[UIApplication sharedApplication] openURL:myURL options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:myURL];
        }
    }
}

+ (void)union_openSystemURL:(NSString *)URL {
    NSURL *sysURL = [NSURL URLWithString:URL];
    if ([[UIApplication sharedApplication] canOpenURL:sysURL]) {
        [[UIApplication sharedApplication] openURL:sysURL];
    }
}

+ (NSString *)union_device {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)union_shortVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)union_bundleIdentifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

@end
