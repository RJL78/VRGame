class Cylinder {

float cylinderBaseSize = 50;
float cylinderHeight = 50;
int cylinderResolution = 40;
PShape openCylinder = new PShape();
PShape cylinderTop = new PShape();
PShape cylinderBottom = new PShape();

Cylinder() {
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  
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

  openCylinder.endShape();
  cylinderTop.endShape();
  cylinderBottom.endShape();
}


void draw() {
  shape(openCylinder);
  shape(cylinderTop);
  shape(cylinderBottom);
}

}