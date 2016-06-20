

/** ---- PHYSICAL CONSTANTS ---- **/
static float normalForce = 1;
static float mu = 0.01;
static float gravityConstant = 1;
static float elasticity = 0.8;

/** ---- DIMENSION CONSTANTS ---- **/
static int screenWidth = 1000;
static int screenHeight = 1000;
static int cameraDist = 1000;

/** ---- OBJECT DECLARATIONS ---- **/
Mover mover = new Mover();

/** ---- GlOBAL VARIABLES ---- **/
Boolean run = true;
boolean zoomPlusClicked = false;
boolean zoomMinusClicked = false;

float minVelocityForScore = 2;
ImageProcessing imgproc;






PGraphics videoFrame; 
int videoFrameHeight = screenHeight/5; 
int videoFrameWidth = screenWidth/5;

int pauseTime = 0;
boolean pause = false;

/** ---- MAIN METHODS ---- **/

void settings() {
  size(screenWidth, screenHeight, P3D);
}


void setup() {
  
  vid = new Movie(this, INPUT_FILENAME); 
  img = createImage(INPUT_WIDTH,INPUT_HEIGHT,RGB);
  
  
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  setupScoreBoard();
  
  
 
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  
  
  
  
}

void draw() {
  perspective();
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
  drawScoreBoard();
  
}

/** --- IO CONTROLS ---- **/


//The following two methods, keyPressed() and keyReleased() allow the user to move in and out of SHIFT mode


void mousePressed(){
  zoomPlusClicked = mouseOverPlusZoom();
  zoomMinusClicked = mouseOverMinusZoom();
}

void keyPressed() {

  if (key == CODED && keyCode == SHIFT) {
    run = false;
  }
  
}

void keyReleased() {
  if (!run && key == CODED && keyCode == SHIFT) {
    run = true;
  }
}

// We use mouseWheel() to allow the user to adjust the sensitivity of the mouse when adjusting the inclination of the board

// MouseReleased() allows us (if and only if in SHIFT mode) to add a new cylinder to the board. 
// This function also checks to make sure that the cylinder is added to a legal spot

void mouseReleased() {
  if( zoomPlusClicked && mouseOverPlusZoom()){
    scoreBarWidth += 2;
  }
  if( zoomMinusClicked && mouseOverMinusZoom() && scoreBarWidth-2>=minScoreBarWidth){
    scoreBarWidth -= 2;
  } 
  zoomPlusClicked = false;
  zoomMinusClicked= false;
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