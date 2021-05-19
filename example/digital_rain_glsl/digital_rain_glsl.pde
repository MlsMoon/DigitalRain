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
    
void setup() {
  size(1280, 960, P2D);
  img = loadImage("leaves.jpg");      
  digitalrain = loadShader("edges.glsl");
  digitalrain.set("iResolution",width,height);
}

void draw() {
  if (enabled == true) 
  {
    digitalrain.set("iTime",(float)millis());
    shader(digitalrain);
  }
  image(img, 0, 0,width,height);
}
    
void mousePressed() {
  enabled = !enabled;
  if (!enabled == true) {
    resetShader();
  }
}
