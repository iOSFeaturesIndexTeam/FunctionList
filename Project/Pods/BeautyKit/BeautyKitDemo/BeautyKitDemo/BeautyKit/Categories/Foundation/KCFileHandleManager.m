//
//  KCFileHandleManager.m
//  KidsCamera
//
//  Created by 王文震 on 2018/5/11.
//  Copyright © 2018年 Beauty,Inc. All rights reserved.
//

#import "KCFileHandleManager.h"

@implementation KCFileHandleManager
+ (void)syncFileHandleRename:(NSString *)sourceFile
              destFile:(NSString *)destFile
         processHandle:(void(^)(CGFloat progress))processHandle
      completionHandle:(void(^)())completionHandle{
    NSFileHandle *srcFdh = [NSFileHandle fileHandleForReadingAtPath:sourceFile];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destFile]) {
        //创建文件
        [[NSFileManager defaultManager] createFileAtPath:destFile contents:nil attributes:nil];
    }

    NSFileHandle *destFdh = [NSFileHandle fileHandleForWritingAtPath:destFile];

    long long filesize = [srcFdh seekToEndOfFile];
    //还得复位到头指针
    [srcFdh seekToFileOffset:0];

    NSLog(@"文件的总长度：%llu",filesize);

    NSLog(@"currentThread:%@",[NSThread currentThread]);
    //注意：在子线程中需要重新开启自动释放池，否则会造成内存泄露
    //一般在方法返回对象时会产生 return  [obj autorelease];
    //而autorelease 需要借助外部的自动释放工具NSAutoReleasePool  drain 方法来释放所有标识过autorealse的对象
    //如果对象要纳入autoreleasepool 自动释放，需要将对象的申请（产生）和释放都放在autorelease作用域中
    NSData *buffer =nil;

    while (YES)
    {
        @autoreleasepool
        {
            //对象获取要放在自动释放池内。
            buffer = [srcFdh readDataOfLength:4096*2];
            if (buffer.length == 0)
            {
                break;
            }
            //写入数据
            [destFdh writeData:buffer];
            buffer = nil;//提前告知ARC，请给我加一个release方法
        }
        //计算进度
        //注意：一定要将整形转换为Float再进行计算
        float progress = ((float)destFdh.offsetInFile/filesize) ;
        //如果要减少进度的更新，可以将进度值放大一点
        NSInteger i = (NSInteger)(progress *1000) %10 ;
        if (i==0)
        {
            if (processHandle) {
                processHandle(progress);
            }
        }
        //能减少CPU的占用
        // [NSThread sleepForTimeInterval:0.0001];
    }
    //刷新缓冲
    [destFdh synchronizeFile];

    NSLog(@"拷贝文件成功！");

    [srcFdh closeFile];
    [destFdh closeFile];
    if (completionHandle) {
        completionHandle();
    }
}
@end
