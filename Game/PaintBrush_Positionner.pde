// This file stores helper methods which serve to move our paintbrush into the desired position
// Their names should be self-explanatory


void moveToCenterOfBoardPlane(){
  translate(screenWidth/2, 4*screenHeight/7, -cameraDist+(screenHeight/2.0)/tan(PI*30.0 / 180.0));
  rotateX(currXIncline);
  rotateZ(currZIncline);
}

void moveToCenterOfScreen(){
  translate(screenWidth/2, screenHeight/2, 0);
}

void movetoUpperRightCorner(){
  translate( screenWidth*0.75, screenHeight*0.1);
}