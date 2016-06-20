import java.lang.Math;
import java.awt.Color;


/** ---- GLOBAL VARIABLES ---- **/
int boxWidth = screenWidth/2;
int boxHeight = 10;
int boxDepth = boxWidth;

int wallHeight = 30;

//The colors are represented with the class jawa.awt.Color for easier manipulation
//int boxColor = new Color(155, 255, 150).getRGB();
int boxColor = new Color(245, 220, 80).getRGB();
//int strokeColor = new Color(205, 50, 10).getRGB();
//int strokeColor = new Color(40, 130, 115).getRGB();
int strokeColor = new Color(139,69,19).getRGB();
//int wallsColor = new Color(255, 153, 0).getRGB();
int wallsColor = new Color(22, 99, 222).getRGB();
int backgroundColor = new Color(0, 155, 255).getRGB();
int ballColor = new Color(strokeColor).getRGB();

//These variables are used for the implementation of the board's rotation
float currXIncline = 0;
float currZIncline = 0;
float XinclineFactor = screenHeight/2; 
float ZinclineFactor = screenWidth/2;
float inclineDelta = 0.015;
float maxInclineDelta = 0.03;
float minInclineDelta = 0.001;
float maxInclination = PI/3;


/** ---- METHODS ---- **/

//This method draws the board with its accessories
void displayBoard() { 

  pushMatrix();
  moveToCenterOfBoardPlane();
  fill(boxColor,127);
  stroke(strokeColor);
  box(boxWidth, boxHeight, boxDepth);
  drawAdditions();
  popMatrix();
} 

//this method is called in displayBoard() and draws the graphical accessories that do not interfere with the gameplay
//such accessories are the walls, and later the addition of rain, clouds, etc..
void drawAdditions() {
  drawWalls();
}

//this method is called in drawAdditions() and draws walls around the board
void drawWalls() {
  pushMatrix();
  fill(wallsColor,127);

  translate(boxWidth/2 + 10 , -10, 0);
  box(20, wallHeight, boxDepth);
  translate(0, 0, boxDepth/2 + 10);
  box(20, wallHeight, 20);

  translate(-boxWidth/2 - 10, 0, 0);
  box(boxWidth, wallHeight, 20);
  translate(-boxWidth/2 - 10, 0, 0);
  box(20, wallHeight, 20);

  translate(0, 0, -boxDepth/2 - 10);
  box(20, wallHeight, boxDepth);
  translate(0, 0, -boxDepth/2 - 10);
  box(20, wallHeight, 20);

  translate(boxWidth/2 + 10, 0, 0);
  box(boxWidth, wallHeight, 20);
  translate(boxWidth/2 + 10, 0, 0);
  box(20, wallHeight, 20);

  popMatrix();
}

//this method draws the walls that only appear in the SHIFT mode, explained in another tab
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