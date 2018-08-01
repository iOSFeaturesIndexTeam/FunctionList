//
//  ListIndex.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/7/31.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#ifndef ListIndex_h
#define ListIndex_h
#import "ViewController.h"
#warning NODO-Wangwz 暂时没有用处
/**
 获取子目录

 @param preIndex 上级目录
 @return 目录索引
 */
static inline NSArray <DemoIndexModel *> *getIndexData(NSString *preIndex){
    return @[DemoIndexModel.new];
};

#pragma mark - 目录索引
/** 一级目录（1） */
static NSString * const CocoTouch_VC = @"CocoTouch";//apple框架
    //-->2
    static NSString * const Img_Animation_VC = @"ImgAnimation";//图形与动画

    static NSString * const Gesture_VC = @"Gesture";//手势

    static NSString * const IO_VC = @"IO";//本地磁盘持久化

    static NSString * const Multimedia_VC = @"Multimedia";//多媒体【音视频、图像、相册】

    static NSString * const SystemService_VC = @"SystemService";//系统服务
        //-->3
        static NSString * const Contact_VC = @"Contact";//通讯录
        static NSString * const Touch3D_VC = @"Touch3D";//3D-touch
        static NSString * const Accelerometer_Gyro_VC = @"AccelerometerGyro";//加速剂、陀螺仪

    static NSString * const Multithreading_VC = @"Multithreading";//多线程

    static NSString * const MessagePush_VC = @"MessagePush";//消息推送
        static NSString * const Local_Romote_VC = @"LocalRomote";//本地推送、【正常远程推送 & 静默推送】
        static NSString * const VOIP_VC = @"Voip";//特殊推送Voip 【视频/语音 通话】

    static NSString * const InstantMessaging_VC = @"InstantMessaging";//即时通讯
        static NSString * const XMPP_VC = @"XMPP";//XMPP
        static NSString * const Bluetooth_VC = @"Bluetooth";//蓝牙

/** 一级目录（2） */
static NSString * const DesignPatterns_VC = @"DesignPatterns";//设计模式

/** 一级目录（3） */
static NSString * const PackagedComponent_VC = @"PackagedComponent";//自定义组件、通用工具类

/** 一级目录（4） */
static NSString * const DataStructure_VC = @"DataStructure";//数据结构
#endif /* ListIndex_h */
