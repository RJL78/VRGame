PVector sphereVelocity = new PVector(0, 0, 0);
PVector spherePositionFromCenter = new PVector(0, 0, 0);
//float sphereSize=20;

void displayBall(){
  
  pushMatrix();
  
  fill(0,255,0);
  moveToCenterOfBoardPlane();
  translate(spherePositionFromCenter.x,spherePositionFromCenter.y-(boxHeight/2+sphereSize),spherePositionFromCenter.z);
  sphere(sphereSize);
  
  popMatrix();
  
}