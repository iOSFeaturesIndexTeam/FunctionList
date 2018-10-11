//
//  LWAsynSerialQueueWaitsTask.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/9.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import "LWSerialQueueWaitsDownloadTask.h"

@interface LWSerialQueueWaitsDownloadTask ()
@property (nonatomic,strong) NSMutableDictionary <NSURL *,NSBlockOperation *>*requestTasks;
@property (nonatomic,strong) NSOperationQueue *queue;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@end

@implementation LWSerialQueueWaitsDownloadTask
+ (LWSerialQueueWaitsDownloadTask *)manager {
    static LWSerialQueueWaitsDownloadTask *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[LWSerialQueueWaitsDownloadTask alloc] init];
    });
    return m;
}
- (instancetype)init{
    if (self = [super init]) {
        _sessionManager = [AFURLSessionManager new];
        _requestTasks = [NSMutableDictionary dictionary];
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;//限制并发任务数量
        _queue.name = @"LWAsynSerialQueueWaitsTask";
    }
    return self;
}

- (LWTaskToken *)requestWithURL:(NSString *)url
                  processHandle:(void (^)(NSProgress *))progressHandler
                    destination:(NSURL *(^)(NSURL *, NSURLResponse *))destination
              completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler{
    NSURL *requestUrl = [NSURL URLWithString:url];
    if (!requestUrl) {
        if (completionHandler) {
            completionHandler(nil,nil,nil);
        }
        return nil;
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSBlockOperation *opreation = [self.requestTasks objectForKey:requestUrl];
    if (!opreation) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
            NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progressHandler) {
                    progressHandler(downloadProgress);
                }
            } destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                dispatch_semaphore_signal(semaphore);
                if (completionHandler) {
                    completionHandler(response, filePath, error);
                }
                [self.requestTasks removeObjectForKey:requestUrl];
            }];
            
            [downloadTask resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }];
        [self.queue addOperation:operation];
        [self.requestTasks setObject:operation forKey:url];
    }
    
    LWTaskToken *taskToken = [LWTaskToken new];
    taskToken.downloadURL = requestUrl;
    return taskToken;
}
- (void)cancleTaskWithToken:(LWTaskToken *)token{
    if (!token.downloadURL) {
        return;
    }
    NSBlockOperation *operation = [self.requestTasks objectForKey:token.downloadURL];
    [operation cancel];
    [self.requestTasks removeObjectForKey:token.downloadURL];
}
- (void)cancleAllTask{
    [self.queue cancelAllOperations];
    [self.requestTasks removeAllObjects];
}

@end

@implementation LWTaskToken


@end
