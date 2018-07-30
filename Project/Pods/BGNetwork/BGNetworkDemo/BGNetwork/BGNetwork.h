//
//  BGNetwork.h
//  BGNetworkDemo
//
//  Created by Little.Daddly on 2018/6/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#ifndef BGNetwork_h
#define BGNetwork_h
typedef void(^BGNetworkCompletionBlcok)(id responseObject, NSError *error);
typedef void(^BGProgressBlock)(NSProgress *progress);
typedef NSURL *(^BGDestinationBlcok)(NSURL *, NSURLResponse *);

typedef NS_ENUM(NSUInteger,BGServerDomainPathType){
    BGServerDomainPathTypeTest,
    BGServerDomainPathTypeRelease,
};

typedef NS_ENUM(NSUInteger,BGRequestMethod){
    BGRequestMethodGet,
    BGRequestMethodPost,
    BGRequestMethodDefault
};

typedef NS_ENUM(NSUInteger,BTRequestSerializerType) {
    BTRequestSerializerTypeHTTP,
    BTRequestSerializerTypeJSON
};

typedef NS_ENUM(NSUInteger,BTResponseSerializerType) {
    BTResponseSerializerTypeHTTP,
    BTResponseSerializerTypeJSON
};

typedef NS_ENUM(NSUInteger,BGUploadType) {
    BGUploadTypeImgPath,
    BGUploadTypeImg,
    BGUploadTypeZipPath,
    BGUploadTypeFilePath
};

static const NSTimeInterval kDEFAULT_REQUEST_TIMEOUT = 8.f;
static NSString * const kBG_ServerDomainPath_KEY = @"kBG_ServerDomainPath_KEY";

static inline void BGSetAPIEnvironment(BGServerDomainPathType type){
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@(type) forKey:kBG_ServerDomainPath_KEY];
    [userDefault synchronize];
}

static inline NSString* intToString(NSInteger num){
    return [NSString stringWithFormat:@"%ld",(long)num];
}

static inline BGServerDomainPathType BGAPIEnvironment(){
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [[userDefault valueForKey:kBG_ServerDomainPath_KEY] integerValue];
}

// 图片存储的地址
static NSString * const kServerImagePath = @"file";
static NSString * const kServerFilePath = @"filePath";
static NSString * const kServerZipPath = @"zipPath";
#endif /* BGNetwork_h */
