#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER


uniform sampler2D texture;//src
uniform sampler2D texture_text;
uniform sampler2D noise_text;

uniform vec2 texOffset;
uniform float iTime;
uniform vec2 iResolution;

varying vec4 vertColor;
varying vec4 vertTexCoord;


float text(vec2 fragCoord)
{
    vec2 uv0 = fragCoord;//uv0: 采样用的
    vec2 uv1 = uv0;//uv1 : offest 
    float slide = 64; // 对图片的切割个数

    uv0 = fract( uv0 *slide);
    uv1 *= slide;// uv1 : [0,slide]
    uv1 -= mod(uv1 , 1);
    uv0 = uv0 +  floor( (sin(iTime/8000 + uv1 *10 + texture(noise_text,fragCoord).rg )+1)*8 )  ;
    

    float text = texture(texture_text, uv0 * 0.0625 ).r;
    
    return text;
}


//in:uv  out : rgb
vec3 rain(vec2 texcoord)
{
  vec2 uv0 = texcoord.xy;
  uv0.x -= mod( uv0.x , 8.0/ iResolution.y );
  float offest = sin(uv0.x*5000+0.598);
  //速度
  float speed=cos(uv0.x*30.0)*0.3 + 0.4; //偏移量+基础量
  float y_scale = 1.7 ;
  float y = fract( offest +uv0.y*y_scale - iTime/1000*speed);
  vec3 baseCol = vec3(0.1,1.,0.35);
  baseCol *= y*(y+1);
  return baseCol;
}


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


  vec3 baseCol = rain( vertTexCoord.st);
  float text = text(vertTexCoord.st);
  


  gl_FragColor = vec4( baseCol * text,1.0);
}
