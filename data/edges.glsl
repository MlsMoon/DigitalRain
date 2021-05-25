#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER_SOBEL

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float rgb_to_gray(vec3 rgb)
{
  return rgb.r * 0.299 + rgb.g * 0.587 + rgb.b * 0.114 ;
}

//边缘检测
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

  float sx = col0 + 2 * col3 + col6 - (col2 + 2 * col5 + col8);
	float sy = col0 + 2 * col1 + col2 - (col6 + 2 * col7 + col8);
	float dist = sx * sx + sy * sy;
	if( dist> 0.1 )
		return vec4(1.0);
	else
    dist *= 30;
    if(dist > 1.)
      dist =1.;
		return  vec4(dist,dist,dist,1.0);

}

void main(void) {
  // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // in this thread:
  // http://www.idevgames.com/forums/thread-3467.html



  gl_FragColor =  sobel(vertTexCoord.st);
}





