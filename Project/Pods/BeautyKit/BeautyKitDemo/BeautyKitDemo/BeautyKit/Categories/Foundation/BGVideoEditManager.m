//
//  VideoEditManager.m
//  GIFCreator
//
//  Created by BeautyHZ on 2017/4/25.
//  Copyright © 2017年 BeautyHZ. All rights reserved.
//

#import "BGVideoEditManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIButton+BTExtension.h"
#import "KCFileHandleManager.h"
#import "BeautyKitMacro.h"
#import "UIImage+BTExtension.h"
#import "NSString+BTExtension.h"
@interface BGVideoEditManager()

@property (strong, nonatomic, nullable) AVAsset *asset;

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;

@property (strong, nonatomic) AVAssetExportSession *exportSession;

@property (nonatomic, strong) NSURL *sourceUrl;

@property (nonatomic,strong) CADisplayLink *displayLink;


@end


@implementation BGVideoEditManager

+ (instancetype)shareManager{
    static BGVideoEditManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BGVideoEditManager alloc] init];
    });
    return manager;
}

+ (instancetype)managerWithUrl:(NSURL *)url {
    BGVideoEditManager *manager = [[BGVideoEditManager alloc] init];
    manager.sourceUrl = url;
    manager.asset = [AVAsset assetWithURL:url];
    manager.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:manager.asset];
    manager.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    manager.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    manager.imageGenerator.appliesPreferredTrackTransform = YES;
    return manager;
}

- (instancetype)initWithComposition:(AVMutableComposition *)composition
                   videoComposition:(AVMutableVideoComposition *)videoComposition
                           audioMix:(AVMutableAudioMix *)audioMix{
    if (self = [super init]) {
        self.mutableComposition = composition;
        self.mutableVideoCompostion = videoComposition;
        self.mutableAudioMix = audioMix;
    }
    return self;
}


- (void)clipTheVideoWithStartTime:(CMTime)startTime endTime:(CMTime)endTime completionHandler:(void(^)(NSURL *destinationUrl))handler {
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {

        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:self.asset presetName:AVAssetExportPresetMediumQuality];
        // Implementation continues.

        long stamp = [[NSDate date] timeIntervalSince1970];

        NSURL *destinationUrl = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.mp4", stamp]]];

        self.exportSession.outputURL = destinationUrl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;

        CMTime start = CMTimeMakeWithSeconds(CMTimeGetSeconds(startTime), self.asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(CMTimeGetSeconds(endTime) - CMTimeGetSeconds(startTime), self.asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;

        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{

            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:

                    KCLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:

                    KCLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:

                    KCLog(@"Export Succeend");
                    if (handler) {
                        handler(destinationUrl);
                    }

                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //
                    //                        UISaveVideoAtPathToSavedPhotosAlbum([self.temUrl relativePath], self,@selector(video:didFinishSavingWithError:contextInfo:), nil);
                    //                    });
                    break;
                default:
                    break;
            }
        }];

    }
}

- (void)getGifImgsFromVideoWithUrl:(NSURL *)url
                               fps:(CGFloat)fps
                 completionHandler:(void(^)(NSArray *gifImgs,BOOL isSuccess))handler{
    //    CGFloat duration = [self getTheDurationOfVideo];
    //
    //    Float64 durationPerFrame = 1.0 / frames;

    NSMutableArray *GifImgs = [[NSMutableArray alloc] init];
    //    for (int i = 1; i < frames * duration + 1; i++){
    //
    //        KCLog(@"%f", i * durationPerFrame);
    //
    //        CMTime time = CMTimeMakeWithSeconds(i*durationPerFrame, 600);
    //
    //        UIImage *frameImg = [UIImage imageWithCGImage:[self getTheCurrentImageAtTime:time]];
    //        [GifImgs addObject:frameImg];
    //
    //    }

    CMTime cmtime = self.asset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数

    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }

    __block NSInteger error_num = 0;

    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (image && !error) {
            [GifImgs addObject:[UIImage imageWithCGImage:image]];
        } else {
            error_num ++;
        }

        if (times.count - error_num == GifImgs.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                KCLog(@"视频合成gif 成功");
                handler(GifImgs,YES);
            });
        }

        if (error_num == times.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                KCLog(@"全 失败");
                handler(GifImgs,NO);
            });
        }

    }];

}

- (CGImageRef)getTheCurrentImageAtTime:(CMTime)currentTime {

    self.imageGenerator.appliesPreferredTrackTransform = YES;

    CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:currentTime actualTime:NULL error:nil];
    return halfWayImage;

}

- (CGFloat)getTheDurationOfVideo {
    return CMTimeGetSeconds(self.asset.duration);
}

- (int32_t)getTheTimeScaleOfVideo {
    return self.asset.duration.timescale;
}

- (CGFloat)getVideoRadio {
    NSArray *tracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
    CGFloat aspectRadio = 1;
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;

        if (t.a + t.b + t.c + t.d == 0) {
            aspectRadio = videoTrack.naturalSize.height / videoTrack.naturalSize.width;
        } else {
            aspectRadio = videoTrack.naturalSize.width / videoTrack.naturalSize.height;
        }

    }
    return aspectRadio;
}


/**
 创建Composition
 */
- (void)createCompositionWithVideo:(void(^)(AVMutableCompositionTrack *videoTrack, AVMutableCompositionTrack *audioTrack, AVMutableComposition *mutableComposition))mediaTracks {

    AVMutableComposition *mutableComposition = [AVMutableComposition composition];

    // 视频资源.
    AVMutableCompositionTrack *mutableCompositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 音频资源
    AVMutableCompositionTrack *mutableCompositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

    if (mediaTracks) {
        mediaTracks(mutableCompositionVideoTrack, mutableCompositionAudioTrack, mutableComposition);
    }

}

- (void)mixVideo:(AVAsset *)asset withAnotherVideo:(AVAsset *)anotherAsset {



    [self createCompositionWithVideo:^(AVMutableCompositionTrack *videoTrack, AVMutableCompositionTrack *audioTrack, AVMutableComposition *mutableComposition) {

        if (!videoTrack | !audioTrack) {
            return ;
        }

        //获取视频的资源信息
        AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

        AVAssetTrack *anotherVideoAssetTrack = [[anotherAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

        AVMutableVideoComposition *videoComposition = [self applyTransformWithFirstVideo:videoAssetTrack secondVideoAssetTrack:anotherVideoAssetTrack videoCompositionTrack:videoTrack];

        //添加视频
        NSError *errorVideo = nil;
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:&errorVideo];
        KCLog(@"%@", errorVideo);
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, anotherVideoAssetTrack.timeRange.duration) ofTrack:anotherVideoAssetTrack atTime:videoAssetTrack.timeRange.duration error:nil];
        KCLog(@"%@", errorVideo);

        NSError *erroraudio = nil;

        //获取音频信息
        AVAssetTrack *audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

        AVAssetTrack *anotherAudioAssetTrack = [[anotherAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

        //添加音频
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetTrack.timeRange.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:&erroraudio];
        KCLog(@"%@", erroraudio);

        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,anotherAudioAssetTrack.timeRange.duration) ofTrack:anotherAudioAssetTrack atTime:videoAssetTrack.timeRange.duration error:&erroraudio];
        KCLog(@"%@", erroraudio);



        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetMediumQuality];

        long stamp = [[NSDate date] timeIntervalSince1970];

        NSURL *destinationUrl = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.mp4", stamp]]];

        exporter.outputURL = destinationUrl;

        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        exporter.videoComposition = videoComposition;

        [exporter exportAsynchronouslyWithCompletionHandler:^{

            dispatch_async(dispatch_get_main_queue(), ^{
                if (exporter.status == AVAssetExportSessionStatusCompleted) {
                    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                    if ([assetsLibrary videoAtPathIsCompatibleWithSavedPhotosAlbum:exporter.outputURL]) {
                        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:exporter.outputURL completionBlock:NULL];
                    }
                } else {
                    KCLog(@"%@", [exporter error]);
                }
            });
        }];

        //        //合成
        //        [self exportVideoWithCompositon:mutableComposition completion:^{
        //            KCLog(@"mixSucceed");
        //
        //        }];

    }];

}

/**
 视频合成

 @param mutableComposition 视频资源处理Composition
 @param handler 处理结果回调
 */
- (void)exportVideoWithCompositon:(AVMutableComposition *)mutableComposition completion:(void(^)())handler{

    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetMediumQuality];

    long stamp = [[NSDate date] timeIntervalSince1970];

    NSURL *destinationUrl = [NSURL fileURLWithPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.mp4", stamp]]];

    exporter.outputURL = destinationUrl;

    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;

    [exporter exportAsynchronouslyWithCompletionHandler:^{

        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                handler();
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                if ([assetsLibrary videoAtPathIsCompatibleWithSavedPhotosAlbum:exporter.outputURL]) {
                    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:exporter.outputURL completionBlock:NULL];
                }
            } else {
                KCLog(@"%@", [exporter error]);
            }
        });
    }];
}

- (AVMutableVideoComposition *)applyTransformWithFirstVideo:(AVAssetTrack *)firstVideoAssetTrack secondVideoAssetTrack:(AVAssetTrack *)secondVideoAssetTrack videoCompositionTrack:(AVMutableCompositionTrack *)videoCompositionTrack
{

    CGSize naturalSizeFirst = CGSizeMake(firstVideoAssetTrack.naturalSize.height, firstVideoAssetTrack.naturalSize.width);
    CGSize naturalSizeSecond = CGSizeMake(secondVideoAssetTrack.naturalSize.height, secondVideoAssetTrack.naturalSize.width);

    int frames = 10;

    float step = (naturalSizeFirst.height - naturalSizeFirst.width) / frames;

    AVMutableVideoCompositionInstruction *firstVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    firstVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration);
    AVMutableVideoCompositionLayerInstruction *firstVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];


    AVMutableVideoCompositionInstruction * secondVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    secondVideoCompositionInstruction.timeRange = CMTimeRangeMake(firstVideoAssetTrack.timeRange.duration, CMTimeAdd(firstVideoAssetTrack.timeRange.duration, secondVideoAssetTrack.timeRange.duration));
    AVMutableVideoCompositionLayerInstruction *secondVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];



    for (int i = 0; i < frames; i++) {

        CGAffineTransform firstTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(step * i, 0), CGAffineTransformMakeScale(pow(0.8, i), pow(0.8, i)));

        CGFloat durationFirst = CMTimeGetSeconds(firstVideoAssetTrack.timeRange.duration);

        CMTime periodFirst = CMTimeMakeWithSeconds(durationFirst * 1.0 * i / frames, 1);

        [firstVideoLayerInstruction setTransform:firstTransform atTime:periodFirst];


#pragma mark second

        CGAffineTransform secondTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(step * i, 0), CGAffineTransformMakeScale(pow(0.8, frames - i), pow(0.8, frames - i)));


        CGFloat durationSecond = CMTimeGetSeconds(secondVideoAssetTrack.timeRange.duration);

        CMTime periodSecond = CMTimeMakeWithSeconds(durationSecond * 1.0 * i / frames, 1);

        [secondVideoLayerInstruction setTransform:secondTransform atTime:CMTimeAdd(firstVideoAssetTrack.timeRange.duration, periodSecond)];


    }

    firstVideoCompositionInstruction.layerInstructions = @[firstVideoLayerInstruction];
    secondVideoCompositionInstruction.layerInstructions = @[secondVideoLayerInstruction];


    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];

    mutableVideoComposition.instructions = @[firstVideoCompositionInstruction, secondVideoCompositionInstruction];
    mutableVideoComposition.renderSize =  CGSizeMake(naturalSizeFirst.height, naturalSizeSecond.width);
    mutableVideoComposition.frameDuration = CMTimeMake(1,30);


#pragma mark - 添加贴纸水印
    CALayer *watermarkLayer = [CALayer layer];
//    UIImage *img = [UIImage imageNamed:@"water"];
    watermarkLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:nil].CGImage);

    CALayer *parentLayer = [CALayer layer];
    parentLayer.backgroundColor = [UIColor blueColor].CGColor;
    CALayer *videoLayer = [CALayer layer];
    videoLayer.backgroundColor = [UIColor redColor].CGColor;

    parentLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
    videoLayer.frame = CGRectMake(0, 0, mutableVideoComposition.renderSize.width, mutableVideoComposition.renderSize.height);
    [parentLayer addSublayer:videoLayer];
    watermarkLayer.bounds = CGRectMake(0, 0, 100, 100);
    watermarkLayer.position = CGPointMake(mutableVideoComposition.renderSize.width/2, mutableVideoComposition.renderSize.height/4);
    [parentLayer addSublayer:watermarkLayer];

    mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];

    return mutableVideoComposition;
}
+ (void)mergeAndExportVideos:(NSArray *)videosPath
                 withOutPath:(NSString *)outpath
             completeHandler:(void (^)(BOOL isSuccess))handler{

    if (!videosPath || videosPath.count == 0) {
        return;
    }
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //音频通道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //图像通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime totalDuration = kCMTimeZero;
    if (videosPath.count > 1) {
        for (int i = 0; i < videosPath.count; i++) {
            //获取视频资源信息
            AVURLAsset *asset = [AVURLAsset assetWithURL:videosPath[i]];
            NSError *errorAudio = nil;
            //获取资源音频
            AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            //通道中加入音频
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetAudioTrack atTime:totalDuration error:&errorAudio];

            NSError *errorVideo = nil;
            AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
            //通道加入图像
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetVideoTrack atTime:totalDuration error:&errorVideo];
            totalDuration = CMTimeAdd(totalDuration, asset.duration);

        }

        //导出
        [self exportWithOutpath:outpath withMixAsset:mixComposition completeHandler:handler];

    } else if (videosPath.count == 1) {//不处理将文件重命名
        dispatch_async(dispatch_get_main_queue(), ^{
            NSFileManager *m = [NSFileManager defaultManager];
            NSString *originalName = [((NSURL *)videosPath.firstObject).absoluteString substringFromIndex:7];
            
            if ([m fileExistsAtPath:originalName]) {
                unlink([outpath UTF8String]);
                [KCFileHandleManager syncFileHandleRename:originalName destFile:outpath processHandle:nil completionHandle:^{
                }];
            }
            BOOL isSuccess = YES;
            if (![m fileExistsAtPath:outpath isDirectory:nil]) {
                isSuccess = NO;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(isSuccess);
                }
            });
        });
    }
}

+ (void)processVideo:(NSURL *)videoPath addBgMusic:(NSURL *)audioPath withOutPath:(NSString *)outpath completeHandler:(void (^)(BOOL isSuccess))handler{
    if (videoPath)
    {
        AVURLAsset *videoAsset = [AVURLAsset assetWithURL:videoPath];
        AVURLAsset *audioAsset = [AVURLAsset assetWithURL:audioPath];
        
        AVMutableComposition *mixComposition = [AVMutableComposition new];
        AVMutableCompositionTrack *videoAssetTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [videoAssetTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject] atTime:kCMTimeZero error:nil];
        if (audioPath)
        {
            AVMutableCompositionTrack *audioAssetTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            CMTime audioTotalDuration = kCMTimeZero;
            
            // 背景音乐过短则循环添加
            while ((audioTotalDuration.value / audioTotalDuration.timescale) < (videoAsset.duration.value /  videoAsset.duration.timescale)) {
                CMTime excessTime = kCMTimeZero;
                CMTime tempTime = CMTimeAdd(audioTotalDuration, audioAsset.duration);
                if ((tempTime.value / tempTime.timescale) > (videoAsset.duration.value / videoAsset.duration.timescale)) {
                    excessTime = CMTimeSubtract(tempTime, videoAsset.duration);
                }
                
                [audioAssetTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(audioAsset.duration, excessTime)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:audioTotalDuration error:nil];
                audioTotalDuration = CMTimeAdd(audioTotalDuration, audioAsset.duration);
            }
        }
        
        if (handler)
        {
            [self exportWithOutpath:outpath withMixAsset:mixComposition completeHandler:handler];
        }
    }
    else
    {
        if (handler)
        {
            handler(NO);
        }
    }
}

+ (void)exportWithOutpath:(NSString *)outpath withMixAsset:(AVMutableComposition *)mixComposition completeHandler:(void (^)(BOOL isSuccess))handler {
    
    unlink([outpath UTF8String]);
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    BGVideoEditManager *manager = [BGVideoEditManager shareManager];
    manager.exportSession = exporter;
    manager.displayLink = nil;
    [manager startDisplay];

    exporter.outputURL = [NSURL fileURLWithPath:outpath];
    exporter.outputFileType = AVFileTypeMPEG4;
    // 输出文件是否网络优化 AVFileTypeMPEG4
    exporter.shouldOptimizeForNetworkUse = YES;

    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch (exporter.status) {
            case AVAssetExportSessionStatusCompleted:
                KCLog(@"合并成功");
            {
                if (handler) {
                    handler(YES);
                }
            }
                break;

            default:
            {
                if (handler) {
                    handler(NO);
                }
            }
                break;
        }
    }];
}

+ (CGFloat)getVideoTimeWihtUrl:(NSURL *)url{

    AVURLAsset *audioAsset=[AVURLAsset URLAssetWithURL:url options:nil];

    CMTime audioDuration=audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);

    return audioDurationSeconds;
}
+ (UIImage *)getImgVideoUrl:(NSURL *)url thumbnailSize:(CGSize)thumbnailSize atTime:(CGFloat)time isKeyImage:(BOOL)isKeyImage{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    if (!CGSizeEqualToSize(thumbnailSize, CGSizeZero)) {
        assetImageGenerator.maximumSize = thumbnailSize;
    }
    __block CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
   

    CMTime myTime = CMTimeMake(time, 1);
    if (!isKeyImage) {
        assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
//        CMTime duration = asset.duration;
    }

    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:myTime actualTime:NULL error:nil];

    if (!thumbnailImageRef){
        KCLog(@"thumbnail Image Generation Error %@", thumbnailImageGenerationError);
    }

    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    if (!CGSizeEqualToSize(thumbnailSize, CGSizeZero)) {
        thumbnailImage =[thumbnailImage imgResize:thumbnailSize];
    }

    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
}

+ (NSMutableArray <UIImage *>*)getImgsByVideoUrl:(NSURL *)url thumbailSize:(CGSize)thumbnailSize framesTime:(NSMutableArray *)framesTime isKeyImg:(BOOL)isKeyImage{

    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    // Assume: @property (strong) AVAssetImageGenerator *imageGenerator;
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
//    if (!CGSizeEqualToSize(thumbnailSize, CGSizeZero)) {
//        imageGenerator.maximumSize = thumbnailSize;
//    }

    NSMutableArray *timeData = [NSMutableArray new];
    for (NSNumber *v in framesTime) {
        CMTime myTime = CMTimeMake([v floatValue], 1);
        if (!isKeyImage) {
            imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
            imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
            //        CMTime duration = asset.duration;
//            myTime = CMTimeMake([v floatValue]*30,30);
        }
        [timeData addObject:[NSValue valueWithCMTime:myTime]];
    }

    NSMutableArray *imgData = [NSMutableArray new];
    __block NSInteger process_step = 0;
    dispatch_semaphore_t semaphore_single = dispatch_semaphore_create(0);
    [imageGenerator generateCGImagesAsynchronouslyForTimes:timeData
                                         completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                             AVAssetImageGeneratorResult result, NSError *error) {
//                                             NSString *requestedTimeString = (NSString *)
//                                             CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
//                                             NSString *actualTimeString = (NSString *)
//                                             CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
//                                             NSLog(@"Requested: %@; actual %@", requestedTimeString, actualTimeString);
                                             process_step++;
                                             if (result == AVAssetImageGeneratorSucceeded) {
                                                 // Do something interesting with the image.
                                                 @autoreleasepool{
                                                     __block CGImageRef thumbnailImageRef = NULL;
                                                     UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:image];
                                                     if (!CGSizeEqualToSize(thumbnailSize, CGSizeZero)) {
                                                         thumbnailImage = [thumbnailImage imgResize:thumbnailSize];
                                                     }

                                                     [imgData addObject:thumbnailImage];
                                                     CGImageRelease(thumbnailImageRef);
                                                 }
                                             }

                                             if (result == AVAssetImageGeneratorFailed) {
                                                 NSLog(@"Failed with error: %@", [error localizedDescription]);
                                             }
                                             if (result == AVAssetImageGeneratorCancelled) {
                                                 NSLog(@"Canceled");
                                             }
                                             if (process_step == timeData.count) {
                                                 dispatch_semaphore_signal(semaphore_single);
                                             }
                                         }];
    dispatch_semaphore_wait(semaphore_single, DISPATCH_TIME_FOREVER);
    return imgData;
}

//+ (void)clipVideoUrl:(NSURL *)videoUrl withRange:(TimeRange)videoRange withOutPath:(NSString *)outpath completeHandler:(void (^)())handler{
//    AVURLAsset *videoAsset = [AVURLAsset assetWithURL:videoUrl];
//    AVMutableComposition *mixComposition = [AVMutableComposition composition];
//    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
//    CMTime clipLength = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);
//
//    CMTime start = CMTimeMakeWithSeconds(CMTimeGetSeconds(startTime), videoAsset.duration.timescale);
//    CMTime duration = CMTimeMakeWithSeconds(CMTimeGetSeconds(clipLength), videoAsset.duration.timescale);
//
//
//    CMTimeRange clipRang = CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(start, duration));
//
//    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//
//    [compositionVideoTrack insertTimeRange:clipRang ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
//    //下面3行代码用于保证后面输出的视频方向跟原视频方向一致
//    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
//    AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
//    [compositionVideoTrack setPreferredTransform:assetVideoTrack.preferredTransform];
//
//    AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    [compositionVoiceTrack insertTimeRange:clipRang ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
//    [VideoEditManager exportWithOutpath:outpath withMixAsset:mixComposition completeHandler:handler];
//}

+ (void)videoUrlStr:(NSURL *)videoUrl andCaptureVideoWithRange:(TimeRange)videoRange output:(NSString *)output
         completion:(void(^)(BOOL isSuccess))completionHandle {

    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];


    AVMutableComposition* mixComposition = [AVMutableComposition composition];

    //开始位置startTime
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
    //截取长度videoDuration
    CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);

    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);

    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];

    //下面3行代码用于保证后面输出的视频方向跟原视频方向一致
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    [compositionVideoTrack setPreferredTransform:assetVideoTrack.preferredTransform];
//    KCLog(@"帧率：%f，比特率：%f", assetVideoTrack.nominalFrameRate,assetVideoTrack.estimatedDataRate);

    AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];

    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:output];

    if ([[NSFileManager defaultManager] fileExistsAtPath:output])
    {
        [[NSFileManager defaultManager] removeItemAtPath:output error:nil];
    }

    assetExportSession.outputFileType = AVFileTypeMPEG4;
    assetExportSession.outputURL = outPutUrl;
    //输出文件是否网络优化
    assetExportSession.shouldOptimizeForNetworkUse = YES;

    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (assetExportSession.status) {
            case AVAssetExportSessionStatusCompleted:
            {
                KCLog(@"视频裁剪 完成");
                if (completionHandle) {
                    completionHandle(YES);
                }
            }
                break;

            default:
            {
                if (completionHandle) {
                    KCLog(@"视频裁剪 失败-- error %@",assetExportSession.error);
                    completionHandle(NO);
                }
            }
                break;
        }
    }];
}

+ (void)saveVideoToLocalWithRotate:(NSURL *)videoPath
             withOutPath:(NSString *)outpath
         completeHandler:(void (^)(BOOL isSuccess))handler{

    KCLog(@"start - %@",[NSString getCurrentTimes]);
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoPath];
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    CGAffineTransform t1;
    CGAffineTransform t2;

    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }

    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;


    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    // Check whether a composition has already been created, i.e, some other tool has already been applied
    // Create a new composition
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];

    // Insert the video and audio tracks from AVAsset
    if (assetVideoTrack != nil) {
        AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
    }
    if (assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
    }


    // Step 2
    // Translate the composition to compensate the movement caused by rotation (since rotation would cause it to move out of frame)
    t1 = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height, 0.0);
    // Rotate transformation
    t2 = CGAffineTransformRotate(t1, BGDegreesToRadians(90));


    // Step 3
    // Set the appropriate render sizes and rotational transforms
    // Create a new video composition
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.renderSize = CGSizeMake(assetVideoTrack.naturalSize.height,assetVideoTrack.naturalSize.width);
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);

    // The rotate transform is set on a layer instruction
    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mutableComposition duration]);
    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:(mutableComposition.tracks)[0]];
    [layerInstruction setTransform:t2 atTime:kCMTimeZero];


    // Step 4
    // Add the transform instructions to the video composition
    instruction.layerInstructions = @[layerInstruction];
    mutableVideoComposition.instructions = @[instruction];


    //导出
    unlink([outpath UTF8String]);
    KCLog(@"end - %@",[NSString getCurrentTimes]);
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL = [NSURL fileURLWithPath:outpath];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.videoComposition = mutableVideoComposition;
    // 输出文件是否网络优化
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{

        switch (exporter.status) {
            case AVAssetExportSessionStatusCompleted: {
                if (handler) {
                    handler(YES);
                }
            }
                break;
            case AVAssetExportSessionStatusFailed: {
                if (handler) {
                    handler(NO);
                }

                KCLog(@"Error = %@",exporter.error);
            }
                break;
            default: {
                if (handler) {
                    handler(NO);
                }
            }
                break;
        }
    }];
}

+ (void)saveVideoToLocal:(NSArray *)videosPath
             withOutPath:(NSString *)outpath
         completeHandler:(void (^)(BOOL isSuccess))handler{

    if (!videosPath || videosPath.count == 0) {
        return;
    }
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //音频通道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //图像通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime totalDuration = kCMTimeZero;

        for (int i = 0; i < videosPath.count; i++) {
            //获取视频资源信息
            AVURLAsset *asset = [AVURLAsset assetWithURL:videosPath[i]];
            NSError *errorAudio = nil;
            //获取资源音频
            AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            //通道中加入音频
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetAudioTrack atTime:totalDuration error:&errorAudio];

            NSError *errorVideo = nil;
            AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];

            [videoTrack setPreferredTransform:assetVideoTrack.preferredTransform];

            //通道加入图像
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetVideoTrack atTime:totalDuration error:&errorVideo];
            totalDuration = CMTimeAdd(totalDuration, asset.duration);
        }

        //导出
        unlink([outpath UTF8String]);
    
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];

        exporter.outputURL = [NSURL fileURLWithPath:outpath];
        exporter.outputFileType = AVFileTypeMPEG4;
        // 输出文件是否网络优化
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            
            switch (exporter.status) {
                case AVAssetExportSessionStatusCompleted: {
                    if (handler) {
                        handler(YES);
                    }
                }
                    break;
                case AVAssetExportSessionStatusFailed: {
                    if (handler) {
                        handler(NO);
                    }
                    
                    KCLog(@"Error = %@",exporter.error);
                }
                    break;
                default: {
                    if (handler) {
                        handler(NO);
                    }
                }
                    break;
            }
        }];
}

- (void)displayTime:(CADisplayLink *)display{
    if (_exportSession && self.delegate && [self.delegate respondsToSelector:@selector(VideoEditManagerAddBgMusicProgress:)]) {
        if (_exportSession.progress == 1) {
            [display invalidate];
        }

        [self.delegate VideoEditManagerAddBgMusicProgress:_exportSession.progress];
    }
}
- (void)startDisplay{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayTime:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
@end

