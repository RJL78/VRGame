import processing.video.*;
// Overview of our pipeline : Input image -> Blurring -> Hue/Brightness/Saturation thresholding -> Sobel -> Hough transform
// We know that this might not be what is expected, but this is what we found worked best. Blurring before the Hue/Brightness/Saturation thresholding also allows us to incoporate intensity thresholding (as a principle) in our pipeline

// Tweakable variables - mess around with these if the board detection is suboptimal 
//  These thresholds are exclusive

float MAX_QUAD_AREA;
float MIN_QUAD_AREA;
int HUE_MIN ; 
int HUE_MAX ;
int BRIGHTNESS_MIN ;
int BRIGHTNESS_MAX ;
int SATURATION_MIN ;
int SATURATION_MAX;
int NEIGHBOURHOOD;
int MIN_VOTES;

double maxRotMeasureDiff ;

PGraphics bestQuadFrame; 
PGraphics houghAccFrame; 
PGraphics sobelFrame;


// THESE CONSTANTS NEED TO BE ADJUSTED ACCORDING TO THE CHARACTERISTICS OF INPUT VIDEO
int INPUT_HEIGHT = 480; 
int INPUT_WIDTH = 640;
String INPUT_FILENAME = "testvideo.mp4";

float scaleFactor = 1.5;

PImage sob = new PImage();
List<PVector> corners = new ArrayList();

TwoDThreeD rtC;
Movie vid;
PImage img;
PGraphics camFrame;



class ImageProcessing extends PApplet {
  Capture cam;


  float rx1, ry1, rz1;
  float rx2, ry2, rz2;
  float rx3, ry3, rz3;

  float lastValidXMeasure = 0;
  float lastValidZMeasure = 0;

  void settings() {
    size( INPUT_WIDTH, INPUT_HEIGHT);
  }

  void setup() {

    MAX_QUAD_AREA = 45000;
    MIN_QUAD_AREA = 17000;
    HUE_MIN = 60; 
    HUE_MAX = 130; 
    BRIGHTNESS_MIN = 50;
    BRIGHTNESS_MAX = 140;
    SATURATION_MIN = 90;
    SATURATION_MAX = 130;
    NEIGHBOURHOOD = 20;
    MIN_VOTES = 20;
    maxRotMeasureDiff = 0.7;


    rtC = new TwoDThreeD(INPUT_WIDTH, INPUT_HEIGHT);


    rx1 = rx2 = rx3 = 0;
    ry1 = ry2 = ry3 = 0;
    rz1 = rz2 = rz3 = 0;

    vid.loop();
    vid.speed(1.0);
    camFrame = createGraphics(INPUT_WIDTH, INPUT_HEIGHT, JAVA2D);
  }

  void draw() {
    vid.read();
    img = vid;
    img.loadPixels();
    background(img);
    mover.newTarget(imgproc.getRotation(img));
  }


  PVector getRotation(PImage currImg) {
    sob = sobel(filterThres(blur(currImg)));
    corners = hough(sob, 6);
    PVector rtV = new PVector(0, 0, 0);
    if (corners.size() == 4 ) {

      rtV = rtC.get3DRotations(corners);
      if ( Math.abs (lastValidXMeasure - rtV.x) < maxRotMeasureDiff && Math.abs (lastValidZMeasure - rtV.z) < maxRotMeasureDiff) {

        rx1 = .2*rx1 + .2*rx2 + .3*rx3 + .4*(float)rtV.x;
        ry1 = .2*ry1 + .2*ry2 + .3*ry3 + .4*(float)rtV.y;
        rz1 = .2*rz1 + .2*rz2 + .3*rz3 + .4*(float)rtV.z;

        rx2 = .2*rx2 + .3*rx3 + .5*(float)rtV.x;
        ry2 = .2*ry2 + .3*ry3 + .5*(float)rtV.y;
        rz2 = .2*rz2 + .3*rz3 + .5*(float)rtV.z;

        rx3 = .2*rx3 + .8 * (float) rtV.x;
        ry3=  .2*ry3 + .8 * (float) rtV.y;
        rz3 = .2*rz3 + .8 * (float) rtV.z;
      }

      lastValidXMeasure = rtV.x;
      lastValidZMeasure = rtV.z;
    } 


    if (corners.size() != 4 || Math.abs (lastValidXMeasure - rtV.x) >= maxRotMeasureDiff || Math.abs (lastValidZMeasure - rtV.z) >= maxRotMeasureDiff )
    {
      rx1 = .2*rx1 + .2*rx2 + .4*rx3 + .1*0;
      ry1 = .2*ry1 + .2*ry2 + .4*ry3 + .1*0;
      rz1 = .2*rz1 + .2*rz2 + .4*rz3 + .1*0;

      rx2 = .5*rx2 + .5*rx3;
      ry2 = .5*ry2 + .5*ry3;
      rz2 = .5*rz2 + .5*rz3;
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
    for (int x=0; x<img.width; x++) {
      for (int y=0; y<img.height; y++) {
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
        result.pixels[x+y*img.width] = color(redsum, greensum, bluesum);
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
        max = max(max, sum);
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
    for (int x=0; x<img.width; x++) {
      for (int y=0; y<img.height; y++) {
        if (verifiesProperties(img.pixels[y*img.width + x])) {

          result.pixels[y*img.width + x] = color(255);
          if (y!=0 )         result.pixels[(y-1)*img.width+x] = color(255);
          if (y!=img.height-1) result.pixels[(y+1)*img.width+x] = color (255);

          if (x!=0) {                   
            result.pixels[y*img.width + x-1] = color(255);
            if (y!=0 )         result.pixels[(y-1)*img.width+x-1] = color(255);
            if (y!=img.height-1) result.pixels[(y+1)*img.width+x-1] = color (255);
          }

          if (x!=img.width-1) {
            result.pixels[y*img.width+x+1] = color(255);
            if (y!=0 )         result.pixels[(y-1)*img.width+x+1] = color(255);
            if (y!=img.height-1) result.pixels[(y+1)*img.width+x+1] = color (255);
          }
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