PImage img;
 
 void settings() {
 size(1600, 600);
 }
 void setup() {
 img = loadImage("board4.jpg");
 noLoop();
 }
 void draw() {
 background(255);
 
 image(img, 0, 0,img.width/2,img.height/2);
 PImage sob = sobel(blur(filterThres(img)));
 image(sob,img.width/2,0,sob.width/2,sob.height/2);
 hough(sob,6);
}
