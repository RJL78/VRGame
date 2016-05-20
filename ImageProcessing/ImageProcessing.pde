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

INPUT_HEIGHT = 600; 
INPUT_WITDH = 800;

PImage img;

void settings() {
  size(INPUT_WIDTH*3/2, INPUT_HEIGHT/2);
}
void setup() {
   img = loadImage("board2.jpg");
   bestQuadFrame = createGraphics(img.width,img.height,JAVA2D);
   houghAccFrame = createGraphics(img.width,img.height,JAVA2D);
   sobelFrame    = createGraphics(img.width,img.height,JAVA2D);
  noLoop();
}

void draw() {
  
  
  
  

  PImage sob = sobel(blur(filterThres(img)));
  sobelFrame.beginDraw();
  sobelFrame.image(sob,0,0);
  sobelFrame.endDraw();
  
 
  bestQuadFrame.beginDraw();
  bestQuadFrame.image(img,0,0);
  hough(sob, 6);
  bestQuadFrame.endDraw();
  
  image(sobelFrame,0,0,img.width/2, img.height/2); 
  image(bestQuad*Frame,img.width,0, img.width/2, img.height/2);
 
  
 
  
  image(sob, img.width/2, 0, sob.width/2, sob.height/2);
  
  
  
}
