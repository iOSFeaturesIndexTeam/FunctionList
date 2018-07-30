//
//  KCSaveToAlbumManager.h
//  KidsCamera
//
//  Created by 王文震 on 2018/1/3.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^completionHandle)(BOOL isSuccess);
@interface KCSaveToAlbumManager : NSObject

/** 单例 */
+ (instancetype)shareManager;

/** 保存图片到相册 */
- (void)saveImgToAlbum:(UIImage *)img handler:(completionHandle)handler;
/** 保存视频到相册 */
- (void)saveVideoToAlbum:(NSURL *)videoPath handler:(completionHandle)handler;
/** 保存gif到相册 */
- (void)saveGifToAlbum:(NSData *)data handler:(completionHandle)handler;
/** 将多张图片保存到相册*/
- (void)writeImages:(NSMutableArray*)images
         completion:(completionHandle)completionHandler;
@end
