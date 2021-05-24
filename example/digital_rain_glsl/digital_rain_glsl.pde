/**
 * Edge Detection
 * 
 * Change the default shader to apply a simple, custom edge detection filter.
 * 
 * Press the mouse to switch between the custom and default shader.
 */

PShader digitalrain;  
PImage img;
boolean enabled = true;
PImage texture_text;
PImage noise_text;
PImage src_Edge;

void setup() {
  size(1280, 960 , P2D);
  frameRate(60);
  img = loadImage("leaves.jpg");    
  texture_text = loadImage("texture_text.png");  
  noise_text = loadImage("noise_text.png");
  digitalrain = loadShader("edges.glsl");
  digitalrain.set("iResolution",(float)width,(float)height);
  digitalrain.set("texture_text",texture_text);
  
}

void draw()
{
  background(255);
  if (enabled == true) 
  {

    digitalrain.set("iTime",(float)millis());
    // shader(digitalrain);
  }
  image(img, 0, 0,width,height);
  filter(digitalrain);
  src_Edge = copy();
}
    
void mousePressed() {
  enabled = !enabled;
  if (!enabled == true) {
    resetShader();
  }
}