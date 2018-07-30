//
//  KCAuthorityManager.h
//  KidsCamera
//
//  Created by Aokura on 2018/2/2.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>

@interface KCAuthorityManager : NSObject

// 是否推送被允许
+ (void)isNotificationServiceStatusOnWithCompletionHandler:(void(^)(BOOL isUserDenied))completionHandler;

// 是否允许相机权限
+ (BOOL)isCameraServiceStatusOn;
+ (void)requestCameraAccessWithCompletionHandler:(void(^)(BOOL isGranted))completionHandler;

// 是否允许相册权限
+ (BOOL)isPhotosServiceStatusOn;
+ (void)requestPhotosAccessWithCompletionHandler:(void(^)(PHAuthorizationStatus status))completionHandler;

// 是否允许音频权限
+ (BOOL)isAudioServiceStatusOn;
+ (void)requestAudioAccessWithCompletionHandler:(void(^)(BOOL isGranted))completionHandler;

// 是否允许地理位置权限
+ (BOOL)isGeographicServiceStatusOn;

@end
