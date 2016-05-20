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

PImage img;

void settings() {
  size(INPUT_WIDTH*3/2, INPUT_HEIGHT/2);
}
void setup() {
   img = loadImage("board2.jpg");
   bestQuadFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   houghAccFrame = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
   sobelFrame    = createGraphics(INPUT_WIDTH,INPUT_HEIGHT,JAVA2D);
  noLoop();
}

void draw() {
  
  
  
  

  PImage sob = sobel(blur(filterThres(img)));
  sobelFrame.beginDraw();
  sobelFrame.image(sob,0,0);
  sobelFrame.endDraw();
  
 
  bestQuadFrame.beginDraw();
  houghAccFrame.beginDraw();
  bestQuadFrame.image(img,0,0);
  hough(sob, 6);
  bestQuadFrame.endDraw();
  houghAccFrame.endDraw();
  
  image(bestQuadFrame, 0            , 0 ,INPUT_WIDTH/2, INPUT_HEIGHT/2); 
  image(houghAccFrame, INPUT_WIDTH/2, 0 ,INPUT_WIDTH/2, INPUT_HEIGHT/2);
  image(sobelFrame   , INPUT_WIDTH  , 0 ,INPUT_WIDTH/2, INPUT_HEIGHT/2);
  
}
