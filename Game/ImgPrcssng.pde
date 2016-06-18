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

/*float MAX_QUAD_AREA = 200000;
float MIN_QUAD_AREA = 15000;
int HUE_MIN = 47; 
int HUE_MAX = 119; 
int BRIGHTNESS_MIN = 53;
int BRIGHTNESS_MAX = 142;
int SATURATION_MIN = 49;
int SATURATION_MAX = 136;
int NEIGHBOURHOOD = 25;
int MIN_VOTES = 120;*/

PGraphics bestQuadFrame; 
PGraphics houghAccFrame; 
PGraphics sobelFrame;

int INPUT_HEIGHT = 600; 
int INPUT_WIDTH = 800;
float scaleFactor = 1.5;

PImage sob = new PImage();
List<PVector> corners = new ArrayList();
TwoDThreeD rtC;



class ImageProcessing extends PApplet {
  Capture cam;
  
  
  float rx1, ry1, rz1;
  float rx2, ry2, rz2;
  float rx3, ry3, rz3;
  
  //PImage img;
  
  /*public ImageProcessing(PImage image){
    img = image;
    rx = ry = rz = 0;
  }*/

void settings() {
  size( (int) (INPUT_WIDTH*3/scaleFactor),(int) (INPUT_HEIGHT/scaleFactor) );
}
void setup() {
   rx1 = rx2 = rx3 = 0;
   ry1 = ry2 = ry3 = 0;
   rz1 = rz2 = rz3 = 0;
   bestQuadFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   houghAccFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   sobelFrame    = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
  noLoop();
}

void draw() {
  //img = loadImage("F:\\Programmation\\VRGame\\Game\\data\\board4.jpg");
  //img.loadPixels();
  
  
  
  
  
  
  //sobelFrame.beginDraw();
  //sobelFrame.image(sob,0,0);
  //sobelFrame.endDraw();
  
 
  //bestQuadFrame.beginDraw();
  //houghAccFrame.beginDraw();
  //bestQuadFrame.image(img,0,0);
  
  //println("rx is " + rx);
  //println("ry is " + ry);
  //println("rz is " + rz);
  
  
  //bestQuadFrame.endDraw();
  //houghAccFrame.endDraw();
  
  //image(bestQuadFrame, 0                        , 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor); 
  //image(houghAccFrame, INPUT_WIDTH/scaleFactor  , 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor);
  //image(sobelFrame   , 2*INPUT_WIDTH/scaleFactor, 0 ,INPUT_WIDTH/scaleFactor, INPUT_HEIGHT/scaleFactor);
  
  
}

PVector getRotation(PImage currImg){
  sob = sobel(filterThres(blur(currImg)));
  corners = hough(sob, 6);
  if(corners.size() == 4){
  PVector rtV = rtC.get3DRotations(corners);
//rx = (float) Math.toDegrees(rtV.x);
//ry = (float) Math.toDegrees(rtV.y);
//rz = (float) Math.toDegrees(rtV.z);

  rx1 = .2*rx1 + .2*rx2 + .3*rx3 + .4*(float)rtV.x;
  ry1 = .2*ry1 + .2*ry2 + .3*ry3 + .4*(float)rtV.y;
  rz1 = .2*rz1 + .2*rz2 + .3*rz3 + .4*(float)rtV.z;
  
  rx2 = .2*rx2 + .3*rx3 + .5*(float)rtV.x;
  ry2 = .2*ry2 + .3*ry3 + .5*(float)rtV.y;
  rz2 = .2*rz2 + .3*rz3 + .5*(float)rtV.z;

  rx3 = .2 * rx3 + .8 * (float) rtV.x;
  ry3= .2 * ry3 + .8 * (float) rtV.y;
  rz3 = .2 * rz3 + .8 * (float) rtV.z;
  
  
  } else {
  rx1 = .6*rx1 + .2*rx2 + .1*rx3 + .1*0;
  ry1 = .6*ry1 + .2*ry2 + .1*ry3 + .1*0;
  rz1 = .6*rz1 + .2*rz2 + .1*rz3 + .1*0;
  
  rx2 = .7*rx2 + .2*rx3 + .1*0;
  ry2 = .7*ry2 + .2*ry3 + .1*0;
  rz2 = .7*rz2 + .2*rz3 + .1*0;

  rx3 = (float) 0.0;
  ry3= (float) 0.0;
  rz3 = (float) 0.0;
  }
  
  
  return new PVector(rx1, ry1, rz1);
  
}
PImage blur(PImage img) {

  float[][] kernel = { { 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};

  float weight =107;
  // create a greyscale image (type: ALPHA) for output

  PImage result = createImage(img.width, img.height, ALPHA);
  for (int x=0; x<img.width;x++) {
    for (int y=0; y<img.height;y++) {
       result.pixels[x+y*img.width]=img.pixels[x+y*img.width];
    }
  }
  int N = 3;
  for (int x=1; x<img.width-1; x++) {
    for (int y=1; y<img.height-1; y++) {
      int redsum = 0;
      int greensum = 0;
      int bluesum = 0;
      for (int i = x - N/2; i<(x+1+N/2); i++) {
        for (int j = y - N/2; j<(y+1+N/2); j++) {
          redsum += red(img.pixels[i+j*img.width])*kernel[j-y+N/2][i-x+N/2];
          greensum += green(img.pixels[i+j*img.width])*kernel[j-y+N/2][i-x+N/2];
          bluesum += blue(img.pixels[i+j*img.width])*kernel[j-y+N/2][i-x+N/2];
        }
      }
      redsum /= weight;
      bluesum /= weight;
      greensum /= weight;
      result.pixels[x+y*img.width] = color(redsum,greensum,bluesum);
    }
  }
  return result;
}

PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  // *************************************
  // Implement here the double convolution
  // *************************************
  float weight = 1.f;
  int N=3;
  for (int x=1; x<img.width-1; x++) {
    for (int y=1; y<img.height-1; y++) {
      int sum_v = 0;
      int sum_h=0;
      for (int i = x - N/2; i<(x+1+N/2); i++) {
        for (int j = y - N/2; j<(y+1+N/2); j++) {
          sum_v += brightness(img.pixels[i+j*img.width])*vKernel[j-y+N/2][i-x+N/2];
          sum_h += brightness(img.pixels[i+j*img.width])*hKernel[j-y+N/2][i-x+N/2];
        }
      }
      sum_v /= weight;
      sum_h /= weight;
      float sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      max = max(max,sum);
      buffer[x + img.width*y] = sum;
    }
  }
  
  
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}


PImage filterThres(PImage img) {
  
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int x=0;x<img.width;x++) {
    for (int y=0; y<img.height;y++) {
      if (verifiesProperties(img.pixels[y*img.width + x])) {
        result.pixels[y*img.width + x] = color(255);
      } else {
        result.pixels[y*img.width +x] = color(0);
      }
    }
  }
  return result;
}

Boolean verifiesProperties(color c) {
  Boolean hue = hue(c)>HUE_MIN && hue(c)<HUE_MAX;
  Boolean brightness = brightness(c)>BRIGHTNESS_MIN && brightness(c)<BRIGHTNESS_MAX;
  Boolean saturation = saturation(c)>SATURATION_MIN && saturation(c)<SATURATION_MAX;
  return hue && brightness && saturation;
}



}