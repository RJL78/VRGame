/*PImage img;
 
 void settings() {
 size(1600, 600);
 }
 void setup() {
 img = loadImage("board4.jpg");
 }
 void draw() {
 background(255);
 PImage sob = sobel(filterThres(img));
 
 image(img, 0, 0,img.width/2,img.height/2);
 hough(sob,6);
 image(sob,img.width/2,0,sob.width/2,sob.height/2);
 
 //hough(sobel(filterThres(img)),72);
 } 
 
 */

import processing.video.*;

Capture cam;
PImage img;
void settings() {
  size(1600, 600);
}

void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void draw() {
  background(0,0,0);
  if (cam.available() == true) {
    cam.read();
    img = cam.get();
    if (img.height!=0 && img.width!=0) {
      PImage sob = sobel(filterThres(img));
      image(img, 0, 0, img.width/2, img.height/2);
      hough(sob, 11);
      image(sob, img.width/2, 0, sob.width/2, sob.height/2);
    }
  }
}