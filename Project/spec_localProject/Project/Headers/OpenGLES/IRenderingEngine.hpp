//
//  IRenderingEngine.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#ifndef IRenderingEngine_h
#define IRenderingEngine_h

//手持设备的物理方向，相当于UIDeviceOrientation。
enum DeviceOrientation {
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationPortraitUpsideDown,
    DeviceOrientationLandscapeLeft,
    DeviceOrientationLandscapeRight,
    DeviceOrientationFaceUp,
    DeviceOrientationFaceDown,
};

//创建渲染器的实例并设置各种OpenGL状态
struct IRenderingEngine* CreateRenderer1();

struct IRenderingEngine* CreateRenderer2();

//OpenGL ES渲染器的接口; 由GLView消费。
struct IRenderingEngine {
    virtual void Initialize(int width,int height)= 0;
    virtual void Render() const = 0;
    virtual void UpdateAnimation(float timeStep)= 0;
    virtual void OnRotate(DeviceOrientation newOrientation)= 0;
    
    virtual~IRenderingEngine(){}
};


#endif /* IRenderingEngine_h */
