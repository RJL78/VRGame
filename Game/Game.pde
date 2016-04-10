

/** ---- PHYSICAL CONSTANTS ---- **/
static float normalForce = 1;
static float mu = 0.01;
static float gravityConstant = 0.3;
static float elasticity = 0.8;

/** ---- DIMENSION CONSTANTS ---- **/
static int screenWidth = 1000;
static int screenHeight = 1000;
static int cameraDist = 600;

/** ---- OBJECT DECLARATIONS ---- **/
Mover mover = new Mover();

/** ---- GlOBAL VARIABLES ---- **/
Boolean run = true;




/** ---- MAIN METHODS ---- **/

void settings() {
  size(screenWidth, screenHeight, P3D);
}


void setup() {
  perspective();
  camera(screenWidth/2, 0.75*screenHeight/2, cameraDist, screenWidth/2, screenHeight/2, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  
}

void draw() {
  background(backgroundColor);
  stroke(0, 0, 255);
  if (run) {  
    mover.update(); 
    mover.checkCollisions();
    displayBoard();
    displayBall();
    displayCylinders();
  } else {
    displaySelector();
  }
}

/** --- IO CONTROLS ---- **/


//The following two methods, keyPressed() and keyReleased() allow the user to move in and out of SHIFT mode

void keyPressed() {

  if (key == CODED && keyCode == SHIFT) {
    run = false;
  }
  switch(key){
  case 'r' : itsRainingMen = (itsRainingMen)? false : true; break;
  case 'c' : if(run) clearCylinders(); break;
              
  
  }
}

void keyReleased() {
  if (!run && key == CODED && keyCode == SHIFT) {
    run = true;
    setup();
  }
}


// We use mouseDragged() to let the user adjust the inclination of the board 

void mouseDragged() {
  if (pmouseY-mouseY > 0 && currXIncline< maxInclination-inclineDelta) {
    currXIncline += inclineDelta;
  } else if (pmouseY-mouseY < 0 && currXIncline> -maxInclination+inclineDelta) {
    currXIncline -= inclineDelta;
  }
  if (pmouseX-mouseX > 0 && currZIncline> -maxInclination+inclineDelta) {
    currZIncline -=inclineDelta;
  } 
  else if (pmouseX-mouseX < 0 &&  currZIncline< maxInclination-inclineDelta) {
   currZIncline+=inclineDelta;
  }

}

// We use mouseWheel() to allow the user to adjust the sensitivity of the mouse when adjusting the inclination of the board

void mouseWheel(MouseEvent event) {
  if (run) {
    if (event.getCount() < 0 && inclineDelta < maxInclineDelta) {
      inclineDelta += 0.001;
    } else if (inclineDelta > minInclineDelta) {
      inclineDelta -= 0.0005;
    }
  }
}

// MouseReleased() allows us (if and only if in SHIFT mode) to add a new cylinder to the board. 
// This function also checks to make sure that the cylinder is added to a legal spot

void mouseReleased() {
  if (!run) {
    PVector cylinderPositionFromCenter = new PVector(mouseX-screenWidth/2, mouseY-screenHeight/2);
    boolean collision = false;
    for (int i=0; i < cylinders.size(); i++ ) {
      if (cylinderPositionFromCenter.dist(cylinderPositions.get(i))
        <= 2*cylinderBaseSize ) {
        collision = true;
      }
    }

    if ( cylinderPositionFromCenter.dist(spherePositionFromCenter) 
      <= (cylinderBaseSize+sphereSize)) {
      collision = true;
    }
    if ( ! collision && cylinderPositionFromCenter.x <  boxWidth/2-cylinderBaseSize  && cylinderPositionFromCenter.x >- boxWidth/2 +cylinderBaseSize &&
      cylinderPositionFromCenter.y <  boxDepth/2 - cylinderBaseSize && cylinderPositionFromCenter.y >- boxDepth/2 +cylinderBaseSize) {
      cylinders.add(makeCylinder());
      cylinderPositions.add(cylinderPositionFromCenter);
    }
  }
}