#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER_SOBEL

uniform sampler2D texture;
uniform vec2 texOffset;
uniform float y_threshold = 0.5;//0-1


varying vec4 vertColor;
varying vec4 vertTexCoord;

float rgb_to_gray(vec3 rgb)
{
  return rgb.r * 0.299 + rgb.g * 0.587 + rgb.b * 0.114 ;
}

//边缘检测
//这是我修改过的sobel边缘检测算子
//正常的边缘检测出来的线过细
//我将边缘线的范围进行了修改
vec4 sobel (vec2  vertTexCoord)
{
  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  float col0 = rgb_to_gray(texture2D(texture, tc0).rgb);
  float col1 = rgb_to_gray(texture2D(texture, tc1).rgb);
  float col2 = rgb_to_gray(texture2D(texture, tc2).rgb);
  float col3 = rgb_to_gray(texture2D(texture, tc3).rgb);
  float col4 = rgb_to_gray(texture2D(texture, tc4).rgb);
  float col5 = rgb_to_gray(texture2D(texture, tc5).rgb);
  float col6 = rgb_to_gray(texture2D(texture, tc6).rgb);
  float col7 = rgb_to_gray(texture2D(texture, tc7).rgb);
  float col8 = rgb_to_gray(texture2D(texture, tc8).rgb);

  float sx = 2 * col0 + 4 * col3 + 2 * col6 - (2 * col2 + 4 * col5 + 2 * col8);
	float sy = 2 * col0 + 4 * col1 + 2 * col2 - (2 * col6 + 4 * col7 + 2 * col8);
	float dist = sx * sx + sy * sy;
	if( dist> 0.1 )
		return vec4(1.0);
	else
    dist *= 15;
    if(dist > 1.)
      dist =1.;
		return  vec4(dist,dist,dist,1.0);

}

void main(void) {

    //用processing中传过来的y阈值线的值
    //可能的优化:使用clip()函数
    //似乎在shader中写if两个分支都需要跑一下
    if(vertTexCoord.t > (1. - y_threshold) )
      gl_FragColor =  sobel(vertTexCoord.st);
    else
    {
      vec2 uv = vertTexCoord.xy;
      uv.x = 1-uv.x;
      gl_FragColor = texture(texture, uv).rgba;
    }
}





