PVector sphereVelocity = new PVector(0, 0);
PVector spherePositionFromCenter = new PVector(0, 0);
//float sphereSize=20;
int ballColor = new Color(strokeColor).getRGB();

void displayBall(){
  
  pushMatrix();
  
  fill(ballColor);
  stroke(ballColor);
  moveToCenterOfBoardPlane();
  translate(spherePositionFromCenter.x,-(boxHeight/2+sphereSize),spherePositionFromCenter.y);
  sphere(sphereSize);
  
  popMatrix();
  
}