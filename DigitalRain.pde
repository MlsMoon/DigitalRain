/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;

Capture cam;
PShader digitalrain;  
PShader edges;
PImage texture_text;
PImage noise_text;
boolean enabled = true;//开关
PImage src_Edge;

void setup() {
  size(1280, 960,P2D);
  frameRate(60);
  cameraInitial();
  texture_text = loadImage("texture_text.png");  
  noise_text = loadImage("noise_text.png");
  digitalrain = loadShader("digitalrain.glsl");
   edges = loadShader("edges.glsl");
  digitalrain.set("iResolution",(float)width,(float)height);
  digitalrain.set("texture_text",texture_text);
  
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  PImage img_cam = cam ; //从摄像机捕获的img
  //转为边缘检测的灰度图
  digitalrain.set("iTime",(float)millis());
  image(img_cam, 0, 0, width, height);
  // filter(THRESHOLD,0.8);
  filter(edges);
  src_Edge = copy();
  image(src_Edge, 0, 0, width, height);
  digitalrain.set("src_edge",src_Edge);
  filter(digitalrain);

}


boolean cameraInitial()
{
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
    return false;
  }
  
   else if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    boolean isopen = false;
    while (!isopen) 
    {
      cameras = Capture.list();
      
      if(cameras.length != 0)
      {
        println("Available cameras:");
        printArray(cameras);
        cam = new Capture(this, cameras[0]);
        cam.start();
        return true;
      }
    }
    exit();
    return false;

  }


  else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
    return true;
  }
}
