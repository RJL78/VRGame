import java.lang.Math;
import java.util.Random;
import java.awt.Color;


/** ---- GLOBAL VARIABLES ---- **/
int boxWidth = screenWidth/2;
int boxHeight = 10;
//int boxDepth = screenHeight/3;
int boxDepth = boxWidth;
int boxColor = new Color(155, 255, 150).getRGB();
int strokeColor = new Color(205, 50, 10).getRGB();
int wallsColor = new Color(255, 153, 0).getRGB();
int backgroundColor = new Color(0, 155, 255).getRGB();

float currXIncline = 0;
float currZIncline = 0;
float XinclineFactor = screenHeight/2; 
float ZinclineFactor = screenWidth/2;
float inclineDelta = 0.015;
float maxInclineDelta = 0.03;
float minInclineDelta = 0.001;
float maxInclination = PI/3;
float rainFrequency = boxWidth * boxDepth / 10000;
boolean itsRainingMen = false;




/** ---- METHODS ---- **/

void displayBoard() { 

  pushMatrix();
  moveToCenterOfBoardPlane();
  fill(boxColor);
  stroke(strokeColor);
  box(boxWidth, boxHeight, boxDepth);
  drawAdditions();
  popMatrix();
} 

void drawAdditions() {
  drawWalls();
  if (itsRainingMen) drawRain();
}

void drawWalls() {
  pushMatrix();
  fill(wallsColor);

  translate(boxWidth/2 + 10, -10, 0);
  box(20, 30, boxDepth);
  translate(0, 0, boxDepth/2 + 10);
  box(20, 30, 20);

  translate(-boxWidth/2 - 10, 0, 0);
  box(boxWidth, 30, 20);
  translate(-boxWidth/2 - 10, 0, 0);
  box(20, 30, 20);

  translate(0, 0, -boxDepth/2 - 10);
  box(20, 30, boxDepth);
  translate(0, 0, -boxDepth/2 - 10);
  box(20, 30, 20);

  translate(boxWidth/2 + 10, 0, 0);
  box(boxWidth, 30, 20);
  translate(boxWidth/2 + 10, 0, 0);
  box(20, 30, 20);

  popMatrix();
}

void drawRain() {  
  pushMatrix();
  stroke(0, 0, 150);
  translate(-boxWidth/2, 0, -boxDepth/2);
  Random r = new Random();
  for (int i = 0; i < rainFrequency; i++) {
    float w = (boxWidth*.9) * r.nextFloat();
    float d = (boxDepth*.9) * r.nextFloat();

    line(w, -100, d, w*1.1, 0, d*1.1);
  }

  popMatrix();
}

void drawShiftWalls() {

  pushMatrix();
  fill(cylinderColor);
  stroke(strokeColor);
  strokeWeight(8);

  translate(boxWidth/2 + 10, 0, 5);
  box(20, boxDepth, 10);
  translate(0, boxDepth/2 + 10, 0);
  box(20, 20, 10);

  translate(-boxWidth/2 - 10, 0, 0);
  box(boxWidth, 20, 10);
  translate(-boxWidth/2 - 10, 0, 0);
  box(20, 20, 10);

  translate(0, -boxDepth/2 - 10, 0);
  box(20, boxDepth, 10);
  translate(0, -boxDepth/2 - 10, 0);
  box(20, 20, 10);

  translate(boxWidth/2 + 10, 0, 0);
  box(boxWidth, 20, 10);
  translate(boxWidth/2 + 10, 0, 0);
  box(20, 20, 10);
  noStroke();
  strokeWeight(1);
  popMatrix();
}