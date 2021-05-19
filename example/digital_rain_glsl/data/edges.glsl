#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;
uniform vec2 iResolution;
uniform float iTime;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) 
{
  // // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // // in this thread:
  // // http://www.idevgames.com/forums/thread-3467.html
  // vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  // vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  // vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  // vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  // vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  // vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  // vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  // vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  // vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  // vec4 col0 = texture2D(texture, tc0);
  // vec4 col1 = texture2D(texture, tc1);
  // vec4 col2 = texture2D(texture, tc2);
  // vec4 col3 = texture2D(texture, tc3);
  // vec4 col4 = texture2D(texture, tc4);
  // vec4 col5 = texture2D(texture, tc5);
  // vec4 col6 = texture2D(texture, tc6);
  // vec4 col7 = texture2D(texture, tc7);
  // vec4 col8 = texture2D(texture, tc8);

  // vec4 sum = 8.0 * col4 - (col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8); 
  // gl_FragColor = vec4(sum.rgb, 1.0) * vertColor;

  vec2 uv0 = vertTexCoord.st;
  uv0.x -= mod(uv0.x, 8.);

  //偏移量
  float offset=sin(uv0.x*15.0);
  //速度
  float speed=cos(uv0.x*3.0)*0.3 + 0.4; //偏移量+基础量

  //y是什么?
  //  uv.y / 分辨率的高度 = 越下面的值越大   [0,1]
  // iTime.speed    = 按speed偏移 
  //offest :  按x位置算出来的偏移
  //darken   减淡
  float y_scale = 2.0;
  float darkenFactor = 1. ;
  float y = fract((uv0.y/iResolution.y*y_scale) + iTime*speed + offset);
  // float y = fract((fragCoord.y/iResolution.y*2));

  vec3 baseCol = vec3(0.1,1,0.35);
  // return (1.0- y )*baseCol * darkenFactor * res ;
  vec3 res = (1.0- y)*(2-y)*baseCol * darkenFactor  ;

  gl_FragColor = vec4(y,y,y,1.);
}
