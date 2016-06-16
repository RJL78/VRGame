  import processing.video.*;
// Overview of our pipeline : Input image -> Blurring -> Hue/Brightness/Saturation thresholding -> Sobel -> Hough transform
// We know that this might not be what is expected, but this is what we found worked best. Blurring before the Hue/Brightness/Saturation thresholding also allows us to incoporate intensity thresholding (as a principle) in our pipeline

// Tweakable variables - mess around with these if the board detection is suboptimal 
//  These thresholds are exclusive
float MAX_QUAD_AREA = 200000;
float MIN_QUAD_AREA = 15000;
int HUE_MIN = 47; 
int HUE_MAX = 119; 
int BRIGHTNESS_MIN = 53;
int BRIGHTNESS_MAX = 142;
int SATURATION_MIN = 49;
int SATURATION_MAX = 136;
int NEIGHBOURHOOD = 25;
int MIN_VOTES = 120;

PGraphics bestQuadFrame; 
PGraphics houghAccFrame; 
PGraphics sobelFrame;


float scaleFactor = 1.5;
PImage sob = new PImage();
List<PVector> corners  = new ArrayList();



class ImageProcessing extends PApplet{
  Capture cam;
  
  
  float rx = 0; 
  float ry = 0; 
  float rz = 0;
  

void settings() {
  size( (int) (INPUT_WIDTH*3/scaleFactor),(int) (INPUT_HEIGHT/scaleFactor) );
}
void setup() {
   bestQuadFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   houghAccFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   sobelFrame    = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
}

void draw() {
  
 
  sobelFrame.beginDraw();
  sobelFrame.image(sob,0,0);
  sobelFrame.endDraw();
  
 
  bestQuadFrame.beginDraw();  
  bestQuadFrame.image(img,0,0);
  bestQuadFrame.endDraw();

  
  image(bestQuadFrame, 0                        , 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor); 
  image(houghAccFrame, INPUT_WIDTH/scaleFactor  , 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor);
  image(sobelFrame   , 2*INPUT_WIDTH/scaleFactor, 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor);
  
  
}

PVector getRotation(PImage currImg){
  sob = sobel(filterThres(blur(currImg)));
  corners = hough(sob, 6);
  if (corners.size() == 4 ){ 
    PVector rtV = rtC.get3DRotations(corners);
    rx = rtV.x;
    ry = rtV.y;
    rz = rtV.z;
    
  }

  return new PVector(rx, ry, rz);
  
}

}