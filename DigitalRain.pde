/**
 * 
 * PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
 * 
 * https://github.com/diwi/PixelFlow.git
 * 
 * A Processing/Java library for high performance GPU-Computing.
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */



import com.jogamp.opengl.GL2;
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture;
import com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;


  
  DwPixelFlow context;
  DwShadertoy shader_digitalRain;

  DwGLTexture tex_0 = new DwGLTexture();
  DwGLTexture tex_1 = new DwGLTexture();
  DwGLTexture tex_2 = new DwGLTexture();

  public void settings() 
  {
    size(1280, 720, P2D);
    smooth(0);
  }
  
  public void setup() {
    surface.setResizable(false);
    
    context = new DwPixelFlow(this);
    context.print();
    context.printGL();
    
    shader_digitalRain = new DwShadertoy(context, "data/digitalRain.frag");
    
    
    // load assets
    PImage img0 = loadImage("data/texture1.png");
    PImage img1 = loadImage("data/noise1.png");
    PImage img2 = loadImage("data/test.png");
    
    // create textures
    tex_0.resize(context, GL2.GL_RGBA8, img0.width, img0.height, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, GL2.GL_LINEAR, GL2.GL_MIRRORED_REPEAT, 4,1);
    tex_1.resize(context, GL2.GL_RGBA8, img1.width, img1.height, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, GL2.GL_LINEAR, GL2.GL_MIRRORED_REPEAT, 4,1);
    tex_2.resize(context, GL2.GL_RGBA8, img2.width, img2.height, GL2.GL_RGBA, GL2.GL_UNSIGNED_BYTE, GL2.GL_LINEAR, GL2.GL_MIRRORED_REPEAT, 4,1);
    
    // copy images to textures
    DwFilter.get(context).copy.apply(img0, tex_0);
    DwFilter.get(context).copy.apply(img1, tex_1);
    DwFilter.get(context).copy.apply(img2, tex_2);
    

    
    frameRate(60);
  }


  public void draw() {
    background(255);
    if(mousePressed){
      shader_digitalRain.set_iMouse(mouseX, height-1-mouseY, mouseX, height-1-mouseY);
    }
    shader_digitalRain.set_iChannel(0, tex_0);
    shader_digitalRain.set_iChannel(1, tex_1);
    shader_digitalRain.set_iChannel(2, tex_2);
    shader_digitalRain.apply(this.g);

    String txt_fps = String.format(getClass().getSimpleName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", width, height, frameCount, frameRate);
    surface.setTitle(txt_fps);
  }
  