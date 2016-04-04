import java.lang.Math;


/** ---- GLOBAL VARIABLES ---- **/
int boxWidth = screenWidth/2;
int boxHeight = 10;
int boxDepth = screenHeight/3;

float currXIncline = 0;
float currZIncline = 0;
float XinclineFactor = screenHeight/2; 
float ZinclineFactor = screenWidth/2;
float inclineDelta = 0.015;
float maxInclineDelta = 0.03;
float minInclineDelta = 0.001;
float maxInclination = PI/3;



/** ---- METHODS ---- **/

void displayBoard() { 
  
  pushMatrix();
  moveToCenterOfBoardPlane();
  fill(255, 0, 0);
  box(boxWidth, boxHeight, boxDepth);
  popMatrix();
   
} 