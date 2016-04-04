

/** ---- PHYSICAL CONSTANTS ---- **/
static float normalForce = 1;
static float mu = 0.01;
static float gravityConstant = 0.3;

/** ---- DIMENSION CONSTANTS ---- **/
static int screenWidth = 1000;
static int screenHeight = 1000;
static int sphereSize = 20;

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

  camera(screenWidth/2, screenHeight/2, cameraDist, screenWidth/2, screenHeight/2, 0, 0, 1, 0);
  perspective();
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  background(255, 255, 255);
  stroke(0, 0, 255);
  line(screenWidth/2, 0, 0, screenWidth/2, screenHeight, 0);
}

void draw() {
  perspective();
  background(255, 255, 255);
  stroke(0, 0, 255);
  line(screenWidth/2, 0, 0, screenWidth/2, screenHeight, 0);
  if (run) {
    mover.update(); 
    mover.checkEdges();
    displayBoard();
    displayBall();
    displayCylinders();
  } else {
    displaySelector();
  }
}

/** --- IO CONTROLS ---- **/



void keyPressed() {

  if (key == CODED && keyCode == SHIFT) {
    run = false;
  }
}

void keyReleased() {
  if (!run && key == CODED && keyCode == SHIFT) {
    run = true;
    setup();
  }
}



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


void mouseWheel(MouseEvent event) {
  if (run) {
    println(inclineDelta);
    if (event.getCount() < 0 && inclineDelta < maxInclineDelta) {
      inclineDelta += 0.001;
    } else if (inclineDelta > minInclineDelta) {
      inclineDelta -= 0.0005;
    }
  }
}

void mouseReleased() {
  if (!run) {
    PVector cylinderPositionFromCenter = new PVector(mouseX-screenWidth/2, mouseY-screenHeight/2);
    boolean collision = false;
    for (int i=0; i < cylinders.size(); i++ ) {
      if ( (cylinderPositionFromCenter.x - cylinderPositions.get(i).x)*(cylinderPositionFromCenter.x - cylinderPositions.get(i).x)
        + (cylinderPositionFromCenter.y - cylinderPositions.get(i).y) *(cylinderPositionFromCenter.y - cylinderPositions.get(i).y)
        <= 2*cylinderBaseSize*2*cylinderBaseSize ) {
        collision = true;
      }
    }

    if ( (cylinderPositionFromCenter.x - spherePositionFromCenter.x)*(cylinderPositionFromCenter.x - spherePositionFromCenter.x)+
      (cylinderPositionFromCenter.y - spherePositionFromCenter.z)*(cylinderPositionFromCenter.y - spherePositionFromCenter.z) 
      <= (cylinderBaseSize+sphereSize)*(cylinderBaseSize+sphereSize) ) {
      collision = true;
    }
    if ( ! collision && cylinderPositionFromCenter.x <  boxWidth/2-cylinderBaseSize  && cylinderPositionFromCenter.x >- boxWidth/2 +cylinderBaseSize &&
      cylinderPositionFromCenter.y <  boxDepth/2 - cylinderBaseSize && cylinderPositionFromCenter.y >- boxDepth/2 +cylinderBaseSize) {
      cylinders.add(makeCylinder());
      cylinderPositions.add(cylinderPositionFromCenter);
    }
  }
}