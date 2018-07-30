//
//  KCSaveToAlbumManager.m
//  KidsCamera
//
//  Created by 王文震 on 2018/1/3.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import "KCSaveToAlbumManager.h"
#import "BeautyKitMacro.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/UTCoreTypes.h>
@interface  KCSaveToAlbumManager()

@property (nonatomic, copy) completionHandle saveImgHandle;
@property (nonatomic, copy) completionHandle saveVideoHandle;
@property (nonatomic, assign)NSInteger error_num;

@end

@implementation KCSaveToAlbumManager

#pragma mark - Init Methods

+ (instancetype)shareManager{
    static KCSaveToAlbumManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KCSaveToAlbumManager alloc] init];
    });
    return manager;
}

#pragma mark - Public Methods

- (void)saveImgToAlbum:(UIImage *)img handler:(completionHandle)handler {
    if (img) {
        [self checkPhotoLibraryAuthorityWithCompletionBlock:^{
            _saveImgHandle = handler;
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }];
    }
}
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (!error) {
        if (_saveImgHandle) {
            _saveImgHandle(YES);
        }
    } else {
        if (_saveImgHandle) {
            _saveImgHandle(NO);
        }
    }
}

- (void)saveVideoToAlbum:(NSURL *)videoPath handler:(completionHandle)handler {
    if (videoPath) {
        [self checkPhotoLibraryAuthorityWithCompletionBlock:^{
            _saveVideoHandle = handler;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoPath path])) {
                UISaveVideoAtPathToSavedPhotosAlbum([videoPath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        if (_saveVideoHandle) {
            _saveVideoHandle(YES);
        }
    } else {
        if (_saveVideoHandle) {
            _saveVideoHandle(NO);
        }
    }
}

- (void)saveGifToAlbum:(NSData *)data handler:(completionHandle)handler {
    if (data) {
        [self checkPhotoLibraryAuthorityWithCompletionBlock:^{
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypeGIF};
            [library writeImageDataToSavedPhotosAlbum:data metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
                KCLog(@"gif Success at Album %@", [assetURL path]);
                if (!error) {
                    if (handler) {
                        handler(YES);
                    }
                } else {
                    if (handler) {
                        handler(NO);
                    }
                }
            }];
        }];
    }
}

#pragma mark - Private Methods

- (void)checkPhotoLibraryAuthorityWithCompletionBlock:(void (^)(void))completionBlock {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusAuthorized) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    } else if (authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *authorityAlert = [[UIAlertView alloc] initWithTitle:@"请打开相册的访问权限" message:@"设置-隐私-相册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [authorityAlert show];
        });
    } else if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self checkPhotoLibraryAuthorityWithCompletionBlock:completionBlock];
        }];
    }
}



- (void)writeImages:(NSMutableArray*)images
           completion:(completionHandle)completionHandler{

    if ([images count] == 0) {//全部保存成功 【失败也处理为成功】
        KCLog(@"没有需要 保存的图片了");
//        _error_num = 0;
        completionHandler(YES);
        return;
    }

    UIImage* image = [images firstObject];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage
                              orientation:ALAssetOrientationUp
                          completionBlock:^(NSURL *assetURL, NSError *error){

        if (error) {
            KCLog(@"writeImages:error = %@", [error localizedDescription]);
//            _error_num ++;
        }

        [images removeObjectAtIndex:0];
        [self writeImages:images completion:completionHandler];
     }];
}
@end
