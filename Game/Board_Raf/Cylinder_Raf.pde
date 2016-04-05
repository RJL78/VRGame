ArrayList<PVector> cylinderPositions = new ArrayList(); 
ArrayList<PShape> cylinders = new ArrayList();
float cylinderBaseSize = 20;
float cylinderHeight = 50;
int cylinderResolution = 20;
PShape openCylinder;
PShape cylinderTop;
PShape cylinderBottom;
PShape cylinder;


PShape makeCylinder() {
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  cylinder = createShape(GROUP);
  openCylinder = createShape();
  cylinderTop = createShape();
  cylinderBottom = createShape();
  
  openCylinder.beginShape(QUAD_STRIP);
  cylinderTop.beginShape(TRIANGLE_FAN);
  cylinderBottom.beginShape(TRIANGLE_FAN);
  
  //draw the border of the cylinder, top and bottom
  cylinderBottom.vertex(0, 0, 0);
  cylinderTop.vertex(0, 0, cylinderHeight);
  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i], 0);
    cylinderBottom.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
    cylinderTop.vertex(x[i], y[i], cylinderHeight);
  }
  cylinderBottom.vertex(x[0], y[0], 0);
  cylinderTop.vertex(x[0], y[0], cylinderHeight);

  cylinderTop.endShape();
  cylinderBottom.endShape();
  openCylinder.endShape();
  
  cylinder.addChild(openCylinder);
  cylinder.addChild(cylinderTop);
  cylinder.addChild(cylinderBottom);
  
  return cylinder;
}

void displayCylinders() {
  pushMatrix(); 
  moveToCenterOfBoardPlane();
  for (int i=0; i<cylinders.size(); i++) {
    pushMatrix(); 
    translate(cylinderPositions.get(i).x, boxHeight/2, cylinderPositions.get(i).y); 
    rotateX(PI/2);
    shape(cylinders.get(i)); 
    popMatrix();
  }
  popMatrix();
}


void displaySelector() {
  
  ortho();
  
  pushMatrix();
  PShape cursorCylinder = makeCylinder();
  translate(mouseX,mouseY,boxHeight/2);
  shape(cursorCylinder);
  popMatrix();
  
  pushMatrix();
  moveToCenterOfScreen();
  fill(255, 0, 0);
  box(boxWidth, boxDepth, boxHeight);

  
  pushMatrix();
  translate(spherePositionFromCenter.x, spherePositionFromCenter.y, (boxHeight/2+sphereSize));
  fill(0, 0, 255);
  sphere(sphereSize);
  popMatrix();
  

  for (int i=0; i<cylinders.size(); i++) {
    pushMatrix(); 
    translate(cylinderPositions.get(i).x, cylinderPositions.get(i).y, boxHeight/2); 
    shape(cylinders.get(i)); 
    popMatrix();
  }

  popMatrix();
}
