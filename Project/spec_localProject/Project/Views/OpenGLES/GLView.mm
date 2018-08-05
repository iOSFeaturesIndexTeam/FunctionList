//
//  GLView.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/EAGLDrawable.h>
#import "mach/mach_time.h"
#import <OpenGLES/ES2/gl.h>

@interface GLView(){
    CADisplayLink *displayLink;
}
@end

@implementation GLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)dealloc {
    if([EAGLContext currentContext] == m_context) {
        [EAGLContext setCurrentContext:nil];
    }
    [displayLink invalidate];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*) super.layer;
        /**
         opaque 在图层上设置属性以指示您不需要Quartz来处理透明度。这是Apple在所有OpenGL程序中推荐的性能优势。别担心，您可以轻松使用OpenGL来处理alpha混合。
         */
        eaglLayer.opaque = YES;
        
        m_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!m_context || ![EAGLContext setCurrentContext:m_context]) { 
            return nil;
        }
        
#if OPEN_ARRLOW
        [self OPENGLInit];
#else
//        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
//        m_context = [[EAGLContext alloc] initWithAPI:api];
        
//        if (!m_context || ForceES1) {
            EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES1;
            m_context = [[EAGLContext alloc] initWithAPI:api];
//        }
        
        if (!m_context || ![EAGLContext setCurrentContext:m_context]) {
            return nil;
        }
        
        if (api == kEAGLRenderingAPIOpenGLES1) {
            NSLog(@"Using OpenGL ES 1.1");
            m_renderingEngine = CreateRenderer1();
        }
//        else {
//            NSLog(@"Using OpenGL ES 2.0");
//            m_renderingEngine = CreateRenderer2();
//        }
        
        [m_context renderbufferStorage:GL_RENDERBUFFER
                          fromDrawable:eaglLayer];
        
        m_renderingEngine->Initialize(CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        [self drawView:nil];
        m_timestamp = CACurrentMediaTime();
        
        displayLink = [CADisplayLink displayLinkWithTarget:self
                                                  selector:@selector(drawView:)];
        
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSDefaultRunLoopMode];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didRotate:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
#endif
        
    }
    return self;
}

#if OPEN_ARRLOW
- (void)OPENGLInit {
    /**
     renderbuffer和framebuffer都是类型GLuint，它是OpenGL用来表示它管理的各种对象的类型。您可以轻松地使用 unsigned int代替GLuint；
     一个用于 渲染缓冲区，另一个用于 帧缓冲区。简而言之，渲染缓冲区是填充了某种类型数据的2D表面（在本例中为颜色），帧缓冲区是一组渲染缓冲区。您将在后面的章节中了解有关帧缓冲对象（FBO）的更多信息
     */
    GLuint framebuffer,renderbuffer;
    glGenFramebuffersOES(1, &framebuffer);
    glGenRenderbuffersOES(1, &renderbuffer);
    
    /**
     将这些对象绑定到管道。绑定对象时，可以通过后续OpenGL操作对其进行修改或使用。绑定渲染缓冲区后，通过将renderbufferStorage消息发送到EAGLContext对象来 分配存储。
     */
    glBindFramebufferOES(GL_FRAMEBUFFER_OES,framebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES,renderbuffer);
    
    [m_context renderbufferStorage:GL_RENDERBUFFER_OES
                      fromDrawable:(CAEAGLLayer *)self.layer];
    /**
     接下来，该 glFramebufferRenderbufferOES命令用于将renderbuffer对象附加到framebuffer
     在此之后，glViewport 发出命令。您可以将此视为设置坐标系
     */
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_COLOR_ATTACHMENT0_OES,
                                 GL_RENDERBUFFER_OES,
                                 renderbuffer);
    
    [self drawView];
    glViewport(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
}

- (void)drawView
{
    /**
     这使用OpenGL的“清除”机制用纯色填充缓冲区。首先使用四个值（红色，绿色，蓝色，alpha）将颜色设置为灰色。然后，发出清除操作。最后，EAGLContext告诉对象将渲染缓冲区呈现给屏幕。大多数OpenGL程序不是直接绘制到屏幕上，而是渲染到缓冲区，然后在原子操作中呈现给屏幕，就像我们在这里做的那样。
     */
    glClearColor(0.5f,0.5f,0.5f,1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [m_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
#else
- (void)didRotate:(NSNotification*)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    m_renderingEngine->OnRotate((DeviceOrientation) orientation);
    [self drawView: nil];
}

- (void)drawView:(CADisplayLink*)displayLink
{
    if (displayLink != nil) {
        float elapsedSeconds = displayLink.timestamp - m_timestamp;
        
        m_timestamp = displayLink.timestamp;
        m_renderingEngine->UpdateAnimation(elapsedSeconds);
    }
    
    m_renderingEngine->Render();
    [m_context presentRenderbuffer:GL_RENDERBUFFER];
}
#endif


@end
