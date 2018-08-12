/**
 使用来简单地将它们嵌入到C/C ++代码中,而不是使用文件I/O读取着色器#include。
 多行字符串在C / C ++中通常很麻烦，但它们可以用一个宏来驯服
 */

#define STRINGIFY(A) #A
const char* SimpleVertexShader = STRINGIFY(

attribute vec4 Position;
attribute vec4 SourceColor;
varying vec4 DestinationColor;
uniform mat4 Projection;
uniform mat4 Modelview;

void main(void)
{
    DestinationColor = SourceColor;
    gl_Position = Projection * Modelview * Position;
}
);
