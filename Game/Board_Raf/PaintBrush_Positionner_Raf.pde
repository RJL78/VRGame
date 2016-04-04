void moveToCenterOfBoardPlane(){
  translate(screenWidth/2, screenHeight/2, 0);
  rotateX(currXIncline);
  rotateZ(currZIncline);
}



void moveToCenterOfScreen(){
  translate(screenWidth/2, screenHeight/2, 0);
}

void movetoUpperRightCorner(){
  translate( screenWidth*0.75, screenHeight*0.1);
}