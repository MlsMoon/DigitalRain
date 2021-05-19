#version 150

#define SAMPLER0 sampler2D // sampler2D, sampler3D, samplerCube
#define SAMPLER1 sampler2D // sampler2D, sampler3D, samplerCube
#define SAMPLER2 sampler2D // sampler2D, sampler3D, samplerCube
#define SAMPLER3 sampler2D // sampler2D, sampler3D, samplerCube

uniform SAMPLER0 iChannel0; // image/buffer/sound    Sampler for input textures 0
uniform SAMPLER1 iChannel1; // image/buffer/sound    Sampler for input textures 1
uniform SAMPLER2 iChannel2; // image/buffer/sound    Sampler for input textures 2
uniform SAMPLER3 iChannel3; // image/buffer/sound    Sampler for input textures 3

uniform vec3  iResolution;           // image/buffer          The viewport resolution (z is pixel aspect ratio, usually 1.0)
uniform float iTime;                 // image/sound/buffer    Current time in seconds
uniform float iTimeDelta;            // image/buffer          Time it takes to render a frame, in seconds
uniform int   iFrame;                // image/buffer          Current frame
uniform float iFrameRate;            // image/buffer          Number of frames rendered per second
uniform vec4  iMouse;                // image/buffer          xy = current pixel coords (if LMB is down). zw = click pixel
uniform vec4  iDate;                 // image/buffer/sound    Year, month, day, time in seconds in .xyzw
uniform float iSampleRate;           // image/buffer/sound    The sound sample rate (typically 44100)
uniform float iChannelTime[4];       // image/buffer          Time for channel (if video or sound), in seconds
uniform vec3  iChannelResolution[4]; // image/buffer/sound    Input texture resolution for each channel





float text(vec2 fragCoord)
{
    //采样chanel1
    vec2 uv = mod(fragCoord.xy, 16.)*.0625;
    vec2 block = fragCoord*.0625 - uv;
    uv = uv*.8+.1; // scale the letters up a bit
    uv += floor(texture(iChannel1, block/iChannelResolution[1].xy + iTime*.002).xy * 16.); // randomize letters
    uv *= .0625; // bring back into 0-1 range
    uv.x = -uv.x; // flip letters horizontally
    return texture(iChannel0, uv).r;
}

vec3 rain(vec2 fragCoord)
{
    vec2 uv0 = fragCoord / iResolution.xy;
    uv0.y = 1.0 - uv0.y ;
    float res =  texture(iChannel2, uv0).r ;
    res = 1 - res;
    res *= 1.75 ;//让亮的地方更亮
    res += 0.75;//让暗的地方亮


    vec2 uv = fragCoord;
    //x -= x取余
	uv.x -= mod(uv.x, 8.);
    //fragCoord.y -= mod(fragCoord.y, 16.);
    
    //偏移量
    float offset=sin(uv.x*15.0);
    //速度
    float speed=cos(uv.x*3.0)*0.3 + 0.4; //偏移量+基础量


    //y是什么?
    //  uv.y / 分辨率的高度 = 越下面的值越大   [0,1]
    // iTime.speed    = 按speed偏移 
    //offest :  按x位置算出来的偏移
    //darken   减淡
    float y_scale = 2.0;
    float darkenFactor = 1. ;
    float y = fract((uv.y/iResolution.y*y_scale) + iTime*speed + offset);
    // float y = fract((fragCoord.y/iResolution.y*2));


    vec3 baseCol = vec3(0.1,1,0.35);
    // return (1.0- y )*baseCol * darkenFactor * res ;
    return (1.0- y)*(2-y)*baseCol * darkenFactor * res ;
}




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    fragColor = vec4(text(fragCoord)*rain(fragCoord),1.0);
    
}










