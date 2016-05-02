ArrayList<PVector> cylinderPositions = new ArrayList(); 
ArrayList<PShape> cylinders = new ArrayList();

float cylinderBaseSize = 20;
float cylinderHeight = 50;
int cylinderResolution = 20;

PShape openCylinder;
PShape cylinderTop;
PShape cylinderBottom;
PShape cylinder;

int cylinderColor = new Color(wallsColor).getRGB();
int ballShiftColor = new Color(ballColor).darker().getRGB();
int strokeShiftColor = new Color(strokeColor).darker().getRGB();
int backgroundShiftColor = new Color(backgroundColor).darker().getRGB();

// makeCylinder() is a maker method to get a new Cylinder, whose size is as defined by the constants

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

// displayCylinders paints the cylinders at their respective positions on the board ( as defined by the vectors of cylinderPositions )

void displayCylinders() {
  pushMatrix(); 
  moveToCenterOfBoardPlane();
  for (int i=0; i<cylinders.size(); i++) {
    pushMatrix(); 
    translate(cylinderPositions.get(i).x, -boxHeight/2, cylinderPositions.get(i).y); 
    rotateX(PI/2);
    fill(cylinderColor);
    noStroke();
    shape(cylinders.get(i)); 
    popMatrix();
  }
  popMatrix();
}

// When in shift mode, we have made the choice to reposition both the camera, as well as all 
// elements in the game ( not with respect to eachother, but rather with respect to the X,Y,Z frame
// DisplaySelector() is what allows us to do so 

void displaySelector() {
  
  ambientLight(255, 200, 150);
  noStroke();
  background(backgroundShiftColor);
  camera(screenWidth/2, screenHeight/2, cameraDist, screenWidth/2, screenHeight/2, 0, 0, 1, 0);
  
  ortho();

  pushMatrix();
  fill(cylinderColor);
  PShape cursorCylinder = makeCylinder();
  translate(mouseX, mouseY, boxHeight/2);
  if(!mouseOverScoreBoard()){
    shape(cursorCylinder);
  }
  popMatrix();

  pushMatrix();
  moveToCenterOfScreen();
  fill(boxColor);
  box(boxWidth, boxDepth, boxHeight);

  drawShiftWalls();

  pushMatrix();
  translate(spherePositionFromCenter.x, spherePositionFromCenter.y, (boxHeight/2+sphereSize));
  fill(ballShiftColor);
  sphere(sphereSize);
  popMatrix();

  fill(cylinderColor);
  for (int i=0; i<cylinders.size(); i++) {
    pushMatrix(); 
    translate(cylinderPositions.get(i).x, cylinderPositions.get(i).y, boxHeight/2); 
    shape(cylinders.get(i)); 
    popMatrix();
  }

  popMatrix();
}