/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;



// Capture cam;
PShader digitalrain;  
PShader edges;
PImage texture_text;
PImage noise_text;
boolean enabled = true;//开关
PImage src_Edge;
MyCamera m_MyCamera ;
float y_threshold = 0; // 0-1 , 0 = none 1 = fullscreen
boolean isPressed = false;

void setup() {


  size(1280, 960,P2D);
  m_MyCamera = new MyCamera(this);
  frameRate(60);
  m_MyCamera.cameraInitial();//初始化相机（自定义了mycamera类）
  texture_text = loadImage("texture_text.png");  
  noise_text = loadImage("noise_text.png");
  digitalrain = loadShader("digitalrain.glsl");
  edges = loadShader("edges.glsl");
  digitalrain.set("iResolution",(float)width,(float)height);
  digitalrain.set("texture_text",texture_text);


}

void draw() {


  //修改y阈值线
  if(isPressed)
  {
    if(y_threshold < 1)
      y_threshold += 0.02;
  }
  else
  {
    if(y_threshold > 0)
      y_threshold -= 0.04;
  }

  if (m_MyCamera.cam.available() == true) {
    m_MyCamera.cam.read();
  }
  PImage img_cam = m_MyCamera.cam ; //从摄像机捕获的img
  //设置shader中的Uniform值
  edges.set("y_threshold",y_threshold);
  digitalrain.set("y_threshold",y_threshold);
  digitalrain.set("iTime",(float)millis());
  //摄像机获取的图像
  image(img_cam, 0, 0, width, height);
    //转为边缘检测的灰度图
  filter(edges);//应用边缘检测shader
  src_Edge = copy();//储存灰度图
  digitalrain.set("src_edge",src_Edge);//用灰度图做buffer生成图像
  filter(digitalrain);//应用shader

}


void keyPressed()
{
  isPressed = true;
}

void keyReleased()
{
  isPressed = false;
}

