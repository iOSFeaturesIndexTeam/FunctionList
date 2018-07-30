//
//  KCAuthorityManager.m
//  KidsCamera
//
//  Created by Aokura on 2018/2/2.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import "KCAuthorityManager.h"
#import "BeautyKitMacro.h"
#import <CoreLocation/CoreLocation.h>
@implementation KCAuthorityManager

+ (void)isNotificationServiceStatusOnWithCompletionHandler:(void (^)(BOOL))completionHandler {
    if (UNION_iOS10_Later) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            UNAuthorizationStatus status = settings.authorizationStatus;
            if (status == UNAuthorizationStatusDenied) {
                completionHandler(YES);
            } else {
                completionHandler(NO);
            }
        }];
    } else {
        BOOL isUserDenied = [[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone;
        completionHandler(isUserDenied);
    }
}

+ (BOOL)isCameraServiceStatusOn {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined;
}

+ (void)requestCameraAccessWithCompletionHandler:(void (^)(BOOL))completionHandler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:completionHandler];
}

+ (BOOL)isPhotosServiceStatusOn {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusNotDetermined;
}

+ (void)requestPhotosAccessWithCompletionHandler:(void (^)(PHAuthorizationStatus))completionHandler {
    [PHPhotoLibrary requestAuthorization:completionHandler];
}

+ (BOOL)isGeographicServiceStatusOn {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return ([CLLocationManager locationServicesEnabled] && status == kCLAuthorizationStatusAuthorizedWhenInUse) || status == kCLAuthorizationStatusNotDetermined;
}

+ (BOOL)isAudioServiceStatusOn {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined;
}

+ (void)requestAudioAccessWithCompletionHandler:(void (^)(BOOL))completionHandler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:completionHandler];
}

@end
