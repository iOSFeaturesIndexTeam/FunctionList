//
//  LWAsynSerialQueueWaitsTask.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/9.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
/** Intro 串行队列下载任务 任务依次等待
 
    场景：多个 zip 贴纸需要远程下载 ，用户点击了 a b c 三套 贴纸，
         按顺序下载 先 a 后 b 在 c。前个任务未执行结束，后面的任务排队
         用户重复点击的请求不进入下载任务队列
 */
@class LWTaskToken;
@interface LWSerialQueueWaitsDownloadTask : NSObject
+ (LWSerialQueueWaitsDownloadTask *)manager;
- (LWTaskToken *)requestWithURL:(NSString *)url
                  processHandle:(void (^)(NSProgress *))progressHandler
                    destination:(NSURL *(^)(NSURL *, NSURLResponse *))destination
              completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler;
- (void)cancleTaskWithToken:(LWTaskToken *)token;
- (void)cancleAllTask;
@end


@interface LWTaskToken : NSObject
@property (nonatomic,strong) NSURL *downloadURL;
@end
