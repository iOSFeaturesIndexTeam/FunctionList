#define STRINGIFY(A) #A
/**
    片元着色器 ， 处理 RGBA 色彩通道
 */
const char* SimpleFragmentShader = STRINGIFY(

varying lowp vec4 DestinationColor;

void main(void)
{
    gl_FragColor = DestinationColor;
}
);
