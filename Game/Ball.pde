PVector sphereVelocity = new PVector(0, 0);
PVector spherePositionFromCenter = new PVector(0, 0);
float sphereSize = 10;

// displayBall paints the ball at the correct position in the plane of the field ( as defined by spherePositionFromCenter )

void displayBall(){
  
  pushMatrix();
 
  fill(ballColor);
  stroke(ballColor);
  moveToCenterOfBoardPlane();
  translate(spherePositionFromCenter.x,-(boxHeight/2+sphereSize),spherePositionFromCenter.y);
  sphere(sphereSize);
  
  popMatrix();
  
}