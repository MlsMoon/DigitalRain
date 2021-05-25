#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER


uniform sampler2D texture;//src
uniform sampler2D texture_text;
uniform sampler2D noise_text;
uniform sampler2D src_edge;

uniform vec2 texOffset;
uniform float iTime;
uniform vec2 iResolution;

varying vec4 vertColor;
varying vec4 vertTexCoord;


float text(vec2 fragCoord)
{
    vec2 uv0 = fragCoord;//uv0: 采样用的
    vec2 uv1 = uv0;//uv1 : offest 
    float slide = 81; // 对图片的切割个数

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

    float res =  texture(src_edge, (1-texcoord)).r ;
    res *= 4. ;//让亮的地方更亮
    res += 0.35;//让暗的地方亮

  vec2 uv0 = texcoord.xy;
  uv0.x -= mod( uv0.x , 8.0/ iResolution.y );
  float offest = sin(uv0.x*5000+0.598);
  //速度
  float speed=cos(uv0.x*30.0)*0.3 + 0.4; //偏移量+基础量
  float y_scale = 1.7 ;
  float y = fract( offest + (1-uv0.y)*y_scale - iTime/1000*speed);
  vec3 baseCol = vec3(0.1,1.,0.35);
  baseCol *= y*(y+1);
  return baseCol*res ;
}


void main(void) 
{
  // // Grouping texcoord variables in order to make it work in the GMA 950. See post #13
  // // in this thread:
  // // http://www.idevgames.com/forums/thread-3467.html



  vec3 baseCol = rain( vertTexCoord.st);
  float text = text(vertTexCoord.st);
  


  gl_FragColor = vec4( baseCol * text,1.0);
}
