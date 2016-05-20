// Tweakable variables - mess around with these if the board detection is suboptimal 
//  These thresholds are exclusive
float MAX_QUAD_AREA = 200000;
float MIN_QUAD_AREA = 20000;
int HUE_MIN = 96; 
int HUE_MAX = 137; 
int BRIGHTNESS_MIN = 65;
int BRIGHTNESS_MAX = 218;
int SATURATION_MIN = 54;
int SATURATION_MAX = 123;
int NEIGHBOURHOOD = 30;


PImage img;
 
 void settings() {
 size(1600, 600);
 }
 void setup() {
 img = loadImage("board2.jpg");
 noLoop();
 }
 void draw() {
 background(255);
 
 image(img, 0, 0,img.width/2,img.height/2);
 PImage sob = sobel(blur(filterThres(img)));
 image(sob,img.width/2,0,sob.width/2,sob.height/2);
 hough(sob,6);
}