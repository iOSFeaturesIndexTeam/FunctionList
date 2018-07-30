//
//  BGVideoEditManager.h
//  GIFCreator
//
//  Created by BeautyHZ on 2017/4/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
typedef struct _TimeRange {
    CGFloat location;
    CGFloat length;
} TimeRange;

@protocol VideoEditManagerDelegate <NSObject>
- (void)VideoEditManagerAddBgMusicProgress:(float)progress;
@end

@interface BGVideoEditManager : NSObject
@property (nonatomic,weak)id<VideoEditManagerDelegate> delegate;

@property (nonatomic,strong)AVMutableComposition *mutableComposition;
@property (nonatomic,strong)AVMutableVideoComposition *mutableVideoCompostion;
@property (nonatomic,strong)AVMutableAudioMix *mutableAudioMix;

+ (instancetype)shareManager;
+ (instancetype)managerWithUrl:(NSURL *)url;

- (instancetype)initWithComposition:(AVMutableComposition *)composition
                   videoComposition:(AVMutableVideoComposition *)videoComposition
                           audioMix:(AVMutableAudioMix *)audioMix;

/**
 合并音频文件和视频

 @param asset 需要合并的视频文件
 @param audio 需要合并的音频文件
 */
- (void)preformWithAsset:(AVAsset *)asset andAudioAsset:(AVAsset *)audio;

- (void)clipTheVideoWithStartTime:(CMTime)startTime endTime:(CMTime)endTime completionHandler:(void(^)(NSURL *destinationUrl))handler;

- (void)mixVideo:(AVAsset *)asset withAnotherVideo:(AVAsset *)anotherAsset;

- (CGImageRef)getTheCurrentImageAtTime:(CMTime)currentTime;

/**
 从视频中导出帧图片
 使用方式：   VideoEditManager *videoManager = [VideoEditManager managerWithUrl:saveUrl];
 [videoManager getGifImgsFromVideoWithUrl:saveUrl fps:4 completionHandler:^(NSArray *gifImgs,BOOL isSuccess) {
 // 将图片数组转为gif 动态图导出到沙盒
 [GIFProduceManager createGIFWithImgs:gifImgs completionHandler:nil];
 }];

 */
- (void)getGifImgsFromVideoWithUrl:(NSURL *)url fps:(CGFloat)fps completionHandler:(void(^)(NSArray *gifImgs,BOOL isSuccess))handler;

- (CGFloat)getTheDurationOfVideo;

- (int32_t)getTheTimeScaleOfVideo;

- (CGFloat)getVideoRadio;



/** =======================  Extend Method ======================*/
/**
 合并多个视频

 @param videosPath 多个视频路径
 @param outpath 合成视频的保存路径
 */
+ (void)mergeAndExportVideos:(NSArray *)videosPath
                 withOutPath:(NSString *)outpath
             completeHandler:(void (^)(BOOL isSuccess))handler;

/**
 为视频资源添加背景音乐

 @param videoPath 视频
 @param audioPath 音频
 @param outpath 保存路径
 @param handler 导出视频后的处理
 */
+ (void)processVideo:(NSURL *)videoPath
          addBgMusic:(NSURL *)audioPath
         withOutPath:(NSString *)outpath
     completeHandler:(void (^)(BOOL isSuccess))handler;
/**
 获取视频总时长

 @param url 视频路径
 @return 时长
 */
+ (CGFloat)getVideoTimeWihtUrl:(NSURL *)url;

/**
 从视频当前时间获取一帧的图片

 @param url 视频路径
 @param thumbnailSize 缩略图大小，指定zero 则返回原始大小
 @param time 当前时间
 @param isKeyImage 是否为关键帧
 @return 帧图片
 */
+ (UIImage *)getImgVideoUrl:(NSURL *)url
              thumbnailSize:(CGSize)thumbnailSize
                     atTime:(CGFloat)time
                 isKeyImage:(BOOL)isKeyImage;
/**
 从视频批量生产缩略图

 @param url 视频资源路径
 @param framesTime 时间点集合
 @param thumbnailSize 缩略图大小，指定zero 则返回原始大小
 @param isKeyImage 是否为关键帧
 @return 返回图片对象集合
 */
+ (NSMutableArray <UIImage *>*)getImgsByVideoUrl:(NSURL *)url
                                    thumbailSize:(CGSize)thumbnailSize
                                      framesTime:(NSMutableArray *)framesTime
                                        isKeyImg:(BOOL)isKeyImage;
/**
 裁剪区域且导出

 @param videoUrl 视频路径
 @param videoRange 裁剪范围
 @param output 导出路径
 @param completionHandle 完成回调
 */
+ (void)videoUrlStr:(NSURL *)videoUrl andCaptureVideoWithRange:(TimeRange)videoRange output:(NSString *)output completion:(void(^)(BOOL isSuccess))completionHandle;

/**
 将视频格式转为 AVFileTypeMPEG4 保存本地

 @param videosPath 视频路径 数组
 @param outpath 保存路径
 @param handler 完成回调
 */
+ (void)saveVideoToLocal:(NSArray *)videosPath
             withOutPath:(NSString *)outpath
         completeHandler:(void (^)(BOOL isSuccess))handler;

/** 将相册的视频旋转后 导出 AVFileTypeMPEG4【场景 系统横屏拍摄后，再从相册中获取 视频被旋转】*/
+ (void)saveVideoToLocalWithRotate:(NSURL *)videoPath
                       withOutPath:(NSString *)outpath
                   completeHandler:(void (^)(BOOL isSuccess))handler;
@end

