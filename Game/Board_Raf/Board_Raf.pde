import java.lang.Math;


/** ---- GLOBAL VARIABLES ---- **/
int boxWidth = screenWidth/2;
int boxHeight = 10;
int boxDepth = screenHeight/3;
int lastPressedX = 0;
int lastPressedY = 0;
float currXIncline = 0;
float currZIncline = 0;
float speedIncline = 1;
float maxInclination = PI/3;

/** ---- METHODS ---- **/

void displayBoard() { 
  
  pushMatrix();
  moveToCenterOfBoardPlane();
  fill(255, 0, 0);
  box(boxWidth, boxHeight, boxDepth);
  popMatrix();
   
} 