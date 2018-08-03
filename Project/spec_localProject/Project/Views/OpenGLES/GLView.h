//
//  GLView.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRenderingEngine.hpp"
#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>

/**
    是否开启hello-opengles
    开启后的代码是 入门级别的 
 */
#define OPEN_ARRLOW  0

#if OPEN_ARRLOW
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#endif


@interface GLView : UIView{
    /** 该m_context字段是指向管理OpenGL上下文的EAGL对象的指针。EAGL是一个小型的Apple特定API，可将iPhone操作系统与OpenGL连接起来。 */
    EAGLContext *m_context;
    /** #Warning
     每次通过OpenGL函数调用修改API状态时，都会在上下文中执行此操作。对于在系统上运行的给定线程，任何时候只有一个上下文可以是当前的。使用iPhone，您的应用程序很少需要多个上下文。由于移动设备上的资源有限，我不建议使用多个上下文。
     */
    IRenderingEngine * m_renderingEngine;
    float m_timestamp;
}


- (void)drawView;
- (void)drawView:(CADisplayLink *)displayLink;
- (void)didRotate:(NSNotification *)notification;
@end
