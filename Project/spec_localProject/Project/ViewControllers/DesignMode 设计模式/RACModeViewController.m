



//
//  RACModeViewController.m
//  spec_localProject
//
//  Created by Little.Daddly on 2019/3/10.
//  Copyright © 2019 Little.Daddly. All rights reserved.
//

#import "RACModeViewController.h"

@interface RACModeViewController ()

@end

@implementation RACModeViewController
/**
    RACSubject 热信号
    RACSingle   冷信号

 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self skip];
//    [self distinctuntilChanged];
//    [self takeLast];
//    [self takeUntil];
//    [self ignore];
//    [self zipWith];
//    [self merge];
//    [self then];
    [self concat];
}
/** 跳过 */
-(void)skip{
    
    //skip传入n跳过前面n个值
    RACSubject * subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    
}
/** 取消同次订阅 只是针对字符串和整型有用，数组对象 混乱 慎用*/
-(void)distinctuntilChanged{
    
    RACSubject * subject = [RACSubject subject];
    //处理解决相同值没必要多次被订阅
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    NSArray *a = @[@"1",@"2"];
    NSString *s = @"sdasd";
    NSString *t = @"wwwsdasd";
    [subject sendNext:t];
    [subject sendNext:s];
    [subject sendNext:s];//不会被订阅
    [subject sendNext:t];
    [subject sendNext:t];
}
/** 获取最后几个结果 */
-(void)takeLast {
    
    RACSubject * subject = [RACSubject subject];
    //取的是最后几个值
    [[subject takeLast:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];//不写会取不到最后要的值
}
/** 直到xx 信号被订阅，便不再收取信号 */
-(void)takeUntil{
    
    
    RACSubject * subject = [RACSubject subject];
    
    RACSubject * subject2 = [RACSubject subject];
    
    [[subject takeUntil:subject2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject2 subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    
    [subject2 sendNext:@3];//调用后不会收到下边发送的内容
    //    [subject2 sendCompleted];//
    [subject2 sendNext:@4];
    [subject sendNext:@8];
}
/** 忽略一些值 */
-(void)ignore{
    
    //    ignore 忽略一些值
    //    ignoreValue 忽略所有的值
    
    RACSubject * subject = [RACSubject subject];
    
    RACSignal * ignoreSignal = [subject ignore:@2];//忽略2
    
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@2];
    
    [subject sendNext:@3];

    
}

-(void)fliter{
//    [[textField.rac_textSignal filter:^BOOL(id value) {
//
//        return [value length] > 5;//返回值就是过滤条件 满足才能获取到
//    }] subscribeNext:^(id x) {
//
//        NSLog(@"%@",x);
//    }];
}
/** 支持异步并发2个请求
    耗时为最长的接口  等所有信号都发送内容的时候才会调用
 */
-(void)zipWith{
    //zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件。
    //使用场:当一个界面多个请求的时候，要等所有请求完成才更新UI
//    RACSubject * signalA = [RACSubject subject];
//
//    RACSubject * signalB = [RACSubject subject];
//
//    RACSignal * zipSignal = [signalA zipWith:signalB];//跟压缩的顺序有关 先A后B
//    //
//    [zipSignal subscribeNext:^(id x) {
//
//        NSLog(@"%@",x);
//    }];
//
//    [signalA sendNext:@1];
//    [signalB sendNext:@2];
    
    RACCommand *req_a = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@{@"1":@"www"}];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    RACCommand *req_b = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@[@"1",@"2"]];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
    RACCommand *req_c = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@[@"3",@"4"]];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
    //压缩信号 订阅
    [[[req_a.executionSignals.switchToLatest zipWith:req_b.executionSignals.switchToLatest] zipWith:req_c.executionSignals.switchToLatest] subscribeNext:^(RACTwoTuple *x) {
        NSDictionary * dic = [(RACTwoTuple *)x.first first];
        NSArray *d1 = [(RACTwoTuple *)x.first second];
        NSArray *d2 = x.second;
        NSLog(@"....%@",x);
    }];
    
    NSLog(@"...");
    [req_a execute:nil];
    [req_b execute:nil];
    [req_c execute:nil];
    
    NSLog(@"不堵塞 主线程");
}
/** 多个信号合并成一个信号，任何一个信号有新值就会调用 ,任何一个信号请求完成都会被订阅到 ,合成后的信号，谁先回来执行谁 */
-(void)merge{
    
    RACSubject * signalA = [RACSubject subject];
    
    RACSubject * signalB = [RACSubject subject];
    
    //组合信号
    RACSignal * mergeSignal = [signalA merge:signalB];
    
    //
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 发送信号---交换位置则数据结果顺序也会交换
    [signalB sendNext:@2];
    [signalA sendNext:@1];
}
/** 信号量是依赖 串行 ， 耗时 A+B请求
    但是不处理A 发送的结果
 */
-(void)then{
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"----发送上部分请求---afn");
            
            [subscriber sendNext:@"上部分数据"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"--发送下部分请求--afn");
            
            [subscriber sendNext:@"下部分数据"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    
    RACSignal * thenSignal = [signalA then:^RACSignal *{
        return signalB;// 返回的信号就是要组合的信号
    }];
    
    NSLog(@"...");
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
/**     信号量是依赖 串行 ， 耗时 A+B请求
        和merge 不同的一点，两次信号均请求
 */
-(void)concat{
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"----发送上部分请求---afn");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"上部分数据"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"--发送下部分请求--afn");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"下部分数据"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    RACSignal * concatSignal = [signalA concat:signalB];
    
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}
@end
