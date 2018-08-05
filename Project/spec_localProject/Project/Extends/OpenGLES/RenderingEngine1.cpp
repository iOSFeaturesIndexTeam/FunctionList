//
//  RenderingEngine1.cpp
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/3.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#include <stdio.h>

#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include "IRenderingEngine.hpp"

static const float RevolutionsPerSecond = 1;//角速度

class RenderingEngine1 : public IRenderingEngine {
public:
    RenderingEngine1();
    void Initialize(int width, int height);
    void Render() const;
    void UpdateAnimation(float timeStep);
    void OnRotate(DeviceOrientation newOrientation);
private:
    float RotationDirection() const;
    float m_desiredAngle;
    float m_currentAngle;//角度
    GLuint m_framebuffer;
    GLuint m_renderbuffer;
};

IRenderingEngine* CreateRenderer1()
{
    return new RenderingEngine1();
}

struct Vertex {
    float Position[2];//point
    float Color[4];//rgba
};

// 定义2个三角形的位置和颜色

/**
    OpenGLES 的 定点坐标是归一化坐标系。默认 原点在窗口 中央点
 */

const Vertex Vertices[] = {
    {{-0.5, -0.866}, {1, 1, 0.5f, 1}},
    {{0.5, -0.866},  {1, 1, 0.5f, 1}},
    {{0, 1},         {1, 1, 0.5f, 1}},
    {{-0.5, -0.866}, {0.5f, 0.5f, 0.5f}},
    {{0.5, -0.866},  {0.5f, 0.5f, 0.5f}},
    {{0, -0.4f},     {0.5f, 0.5f, 0.5f}},
};

RenderingEngine1::RenderingEngine1()
{
    //创建 渲染 缓存 并绑定
    glGenRenderbuffersOES(1, &m_renderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_renderbuffer);
}

void RenderingEngine1::Initialize(int width, int height)
{
    // Create the framebuffer object and attach the color buffer.
    glGenFramebuffersOES(1, &m_framebuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_framebuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES,
                                 GL_COLOR_ATTACHMENT0_OES,
                                 GL_RENDERBUFFER_OES,
                                 m_renderbuffer);
    
    glViewport(0, 0, width, height);
    
    glMatrixMode(GL_PROJECTION);
    
    // 初始化投影矩阵。
    const float maxX = 2;
    const float maxY = 3;
    glOrthof(-maxX, +maxX, -maxY, +maxY, -1, 1);
    
    glMatrixMode(GL_MODELVIEW);
    
    // Initialize the rotation animation state.
    OnRotate(DeviceOrientationPortrait);
    m_currentAngle = m_desiredAngle;
}

void RenderingEngine1::Render() const
{
    glClearColor(0.5f, 0.5f, 0.5f, 1);
    glClear(GL_COLOR_BUFFER_BIT);//将渲染缓冲区清除为灰色。
    
    /** 调用glPushMatrix 并glPopMatrix 防止 形变累积 */
    glPushMatrix();
    glRotatef(m_currentAngle, 0, 0, 1);
    glEnableClientState(GL_VERTEX_ARRAY);//启用两个顶点属性（位置和颜色）
    glEnableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, sizeof(Vertex), &Vertices[0].Position[0]);//告诉OpenGL如何获取位置和颜色属性的数据
    glColorPointer(4, GL_FLOAT, sizeof(Vertex), &Vertices[0].Color[0]);
    
    GLsizei vertexCount = sizeof(Vertices) / sizeof(Vertex);
    /**
     执行draw命令 glDrawArrays，指定 GL_TRIANGLES拓扑，0表示起始顶点，以及vertexCount顶点数。此函数调用标记OpenGL从前面gl*Pointer调用中指定的指针中获取数据的确切时间 ; 这也是三角形实际渲染到目标表面的时候
     */
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
    /**
     禁用两个顶点属性; 它们只需在前面的绘图命令中启用。保持启用属性是不好的形式，因为后续绘制命令可能想要使用完全不同的顶点属性集。在这种情况下，我们可以在不禁用它们的情况下使用它
     */
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glPopMatrix();
}

float RenderingEngine1::RotationDirection() const
{
    float delta = m_desiredAngle - m_currentAngle;
    if (delta == 0)
        return 0;

    bool counterclockwise = ((delta > 0 && delta <= 180) || (delta < -180));
    return counterclockwise ? +1 : -1;
}

void RenderingEngine1::UpdateAnimation(float timeStep)
{
    float direction = RotationDirection();
    if (direction == 0)
        return;
    
    float degrees = timeStep * 360 * RevolutionsPerSecond;
    m_currentAngle += degrees * direction;

    // 确保角度保持在[0,360]之内。
    if (m_currentAngle >= 360)
        m_currentAngle -= 360;
    else if (m_currentAngle < 0)
        m_currentAngle += 360;

    // 如果旋转方向改变
    if (RotationDirection() != direction)
        m_currentAngle = m_desiredAngle;
}

void RenderingEngine1::OnRotate(DeviceOrientation orientation)
{
    float angle = 0;

    switch (orientation) {
        case DeviceOrientationLandscapeLeft:
            angle = 270;
            break;

        case DeviceOrientationPortraitUpsideDown:
            angle = 180;
            break;

        case DeviceOrientationLandscapeRight:
            angle = 90;
            break;
    }

    m_desiredAngle = angle;
}
//
