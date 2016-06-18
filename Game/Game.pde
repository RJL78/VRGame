

/** ---- PHYSICAL CONSTANTS ---- **/
static float normalForce = 1;
static float mu = 0.01;
static float gravityConstant = 0.3;
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
PVector rot;
//PImage imgTest;
Movie vid;


PImage img = new PImage();

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
  
 vid = new Movie(this, "F:\\Programmation\\VRGame\\Game\\data\\testvideo.mp4"); 
  vid.loop();


videoFrame =  createGraphics(videoFrameWidth,videoFrameHeight,JAVA2D);
//  camera(screenWidth/2, 0.75*screenHeight/2, cameraDist, screenWidth/2, screenHeight/2, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  setupScoreBoard();
  //imgTest = loadImage("board.jpg");
  //img = loadImage("F:\\Programmation\\VRGame\\Game\\data\\board3.jpg");
  
  img = createImage(INPUT_WIDTH,INPUT_HEIGHT,RGB);
  rtC = new TwoDThreeD(INPUT_WIDTH, INPUT_HEIGHT);
 
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  
  
  
  
}
void movieEvent(Movie m) {
  m.read();
}

void draw() {
  perspective();
  background(backgroundColor);
  stroke(0, 0, 255);
  img = vid;
    img.loadPixels();
  rot = imgproc.getRotation(img);
  if (run) {  
    mover.update(rot); 
    mover.checkCollisions();
    displayBoard();
    displayBall();
    displayCylinders();
    //delay(pauseTime);
    
    
  } else {
    displaySelector();
  }
  drawScoreBoard();
  videoFrame.beginDraw(); 
  PImage imgCopy = img.copy();
  imgCopy.resize(videoFrameWidth,videoFrameHeight);
  videoFrame.background(255);
  videoFrame.image(imgCopy,0,0);
  videoFrame.endDraw();
  
  
  
  image(videoFrame, screenWidth-videoFrameWidth, 0, videoFrameWidth, videoFrameHeight);
  
}

/** --- IO CONTROLS ---- **/


//The following two methods, keyPressed() and keyReleased() allow the user to move in and out of SHIFT mode


void mousePressed(){
  zoomPlusClicked = mouseOverPlusZoom();
  zoomMinusClicked = mouseOverMinusZoom();
  //pauseTime = (pauseTime == 0) ? 3000 : 0;
  //pause = (pause)? false : true;
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


// We use mouseDragged() to let the user adjust the inclination of the board 

void mouseDragged() {
  if(!mouseOverScoreBoard()){
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