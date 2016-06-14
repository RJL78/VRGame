  import processing.video.*;
// Overview of our pipeline : Input image -> Blurring -> Hue/Brightness/Saturation thresholding -> Sobel -> Hough transform
// We know that this might not be what is expected, but this is what we found worked best. Blurring before the Hue/Brightness/Saturation thresholding also allows us to incoporate intensity thresholding (as a principle) in our pipeline

// Tweakable variables - mess around with these if the board detection is suboptimal 
//  These thresholds are exclusive
float MAX_QUAD_AREA = 200000;
float MIN_QUAD_AREA = 20000;
int HUE_MIN = 43; 
int HUE_MAX = 136; 
int BRIGHTNESS_MIN = 65;
int BRIGHTNESS_MAX = 163;
int SATURATION_MIN = 21;
int SATURATION_MAX = 92;
int NEIGHBOURHOOD = 25;
int MIN_VOTES = 200;

PGraphics bestQuadFrame; 
PGraphics houghAccFrame; 
PGraphics sobelFrame;

int INPUT_HEIGHT = 600; 
int INPUT_WIDTH = 800;
float scaleFactor = 1.5;



class ImageProcessing extends PApplet {
  Capture cam;
  
  
  float rx, ry, rz;
  
  PImage img;

void settings() {
  size( (int) (INPUT_WIDTH*3/scaleFactor),(int) (INPUT_HEIGHT/scaleFactor) );
}
void setup() {
   
   bestQuadFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   houghAccFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   sobelFrame    = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
  noLoop();
}

void draw() {
  img = loadImage("F:\\Programmation\\VRGame\\Game\\data\\board4.jpg");
  //img.loadPixels();
  
  
  
  
  TwoDThreeD rtC = new TwoDThreeD(INPUT_WIDTH, INPUT_HEIGHT);
  PImage sob = sobel(filterThres(blur(img)));
  sobelFrame.beginDraw();
  sobelFrame.image(sob,0,0);
  sobelFrame.endDraw();
  
 
  bestQuadFrame.beginDraw();
  houghAccFrame.beginDraw();
  bestQuadFrame.image(img,0,0);
  List<PVector> corners = hough(sob, 6);
  PVector rtV = rtC.get3DRotations(corners);
  rx = (float) Math.toDegrees(rtV.x);
  ry = (float) Math.toDegrees(rtV.y);
  rz = (float) Math.toDegrees(rtV.z);
  println("rx is " + rx);
  println("ry is " + ry);
  println("rz is " + rz);
  bestQuadFrame.endDraw();
  houghAccFrame.endDraw();
  
  image(bestQuadFrame, 0                        , 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor); 
  image(houghAccFrame, INPUT_WIDTH/scaleFactor  , 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor);
  image(sobelFrame   , 2*INPUT_WIDTH/scaleFactor, 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor);
  
  
}

PVector getRotation(){
  return new PVector(rx, ry, rz);
  
}

}