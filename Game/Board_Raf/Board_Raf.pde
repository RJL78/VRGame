import java.lang.Math;
/** ---- DIMENSIONS ---- **/
int screenWidth = 1000;
int screenHeight = 1000;

int boxWidth = 400;
int boxHeight = 10;
int boxDepth = 250;
int sphereSize = 20;

/** ---- GLOBAL VARIABLES ---- **/

int lastPressedX = 0;
int lastPressedY = 0;
float currXIncline = 0;
float currZIncline = 0;
float speedIncline = 1;
float maxInclination = PI/3;

PVector gravityForce = new PVector(0,0,0);
PVector sphereVelocity = new PVector(0,0,0);
PVector spherePositionFromCenter = new PVector(0,0,0);

/** ---- PHYSICAL CONSTANTS ---- **/
float normalForce = 1;
float mu = 0.01;
float gravityConstant = 0.1;


/** ---- METHODS ---- **/
void settings() {
  size(screenWidth, screenHeight, P3D);
}


void setup() {
  background(255, 255, 255);
}

void draw() { 


  gravityForce.x =  sin(currZIncline) * gravityConstant;
  gravityForce.z = - sin(currXIncline) * gravityConstant;
  
  System.out.println("Gravity force in z direction => "+gravityForce.x +" Gravity force in z direction =>" + gravityForce.z);
  
  float frictionMagnitude = normalForce * mu;
  PVector friction = sphereVelocity.get();
  friction.mult(-1);
  friction.normalize();
  friction.mult(frictionMagnitude);
  
  sphereVelocity.add(gravityForce).add(friction);
  spherePositionFromCenter.add(sphereVelocity);
  
  camera(screenWidth/2, screenHeight/2, 600, screenWidth/2, screenHeight/2, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  background(255, 255, 255);
  
  checkEdges();
  
  stroke(0, 0, 255);
  line(screenWidth/2, 0, 0, screenWidth/2, screenHeight, 0);
  
  translate(screenWidth/2, screenHeight/2, 0);
  
  rotateX(currXIncline);
  rotateZ(currZIncline);
  
  fill(255, 0, 0);
  box(boxWidth, boxHeight, boxDepth);
  
  fill(0,255,0);
  translate(spherePositionFromCenter.x,spherePositionFromCenter.y-(boxHeight/2+sphereSize),spherePositionFromCenter.z);
  sphere(sphereSize);
} 

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e<0) {
    speedIncline *= 1.01;
  } else {
    speedIncline *= 0.99;
  }
  System.out.println(speedIncline);
}

void mousePressed() {
  lastPressedX = mouseX;
  lastPressedY = mouseY;
}

void mouseReleased() {
  float deltaX = (mouseX - lastPressedX)/((float)screenWidth);
  float deltaY = ( - mouseY + lastPressedY)/((float)screenHeight);

  float rotZ =  deltaX * maxInclination * speedIncline;
  float rotX = deltaY * maxInclination * speedIncline;

  if (rotX + currXIncline > maxInclination ) {
    rotX = maxInclination - currXIncline;
  } else if ( rotX + currXIncline < - maxInclination) {
    rotX = -maxInclination - currXIncline;
  }


  if (rotZ + currZIncline > maxInclination ) {
    rotZ = maxInclination - currZIncline;
  } else if ( rotZ + currZIncline < -maxInclination) {
    rotZ = -maxInclination - currZIncline;
  }

  currZIncline += rotZ; 
  currXIncline += rotX;
}


// PROBLEM : BALL GETS STUCK ON EDGES!
void checkEdges() {
    if (Math.abs(spherePositionFromCenter.x) > boxWidth/2) {
      sphereVelocity.x = -sphereVelocity.x;
    }
    if (Math.abs(spherePositionFromCenter.z) > boxDepth/2) {
      sphereVelocity.z = -sphereVelocity.z;
    }
}
   