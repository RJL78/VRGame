float e = 1;
float mY = 500/2;
float mX = 500/2;
float ballRadius = 5.0;
float plateWidth = 5.0;
float plateSize = 200.0;
Mover mover;
Plate plate;
boolean shiftModeOn = false;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
  plate = new Plate(plateSize, plateWidth);
  mover = new Mover(plate, ballRadius);
}

void draw() {
  if (!shiftModeOn) {
    camera(width/2, height/2 - 100, plateSize*1.5, width/2, height/2, 0, 0, 1, 0);
  } else {
    plate.getCamAbove();
  }
  directionalLight(50, 100, 125, 1, 1, 0);
  ambientLight(102, 102, 102);
  background(220, 240, 250);  
  plate.update();

  if (shiftModeOn) {
  } else {
    mover.moveBall();
    mover.checkedges();
  }
  mover.drawSphere();
}

void mouseWheel(MouseEvent event) {
  if (event.getCount() <0 && e<10) {
    e=e+0.05;
  } else if (e>1) e=e-0.05;
}

void mouseDragged() {
    if (pmouseY-mouseY > 0 && mY>0) {
    mY=mY-e;
    } else if (pmouseY-mouseY < 0 && mY<height) mY=mY+e;
    if (pmouseX-mouseX > 0 && mX>0) {
    mX=mX-e;
    } else if (pmouseX-mouseX < 0 && mX<width) mX=mX+e;
  
}

void keyPressed() {
  switch(key) {
  case CODED:
    if (keyCode == UP) {
      shiftModeOn=true;
    }
    break;
  default:
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    if (keyCode == UP) {
      shiftModeOn=false;
    }
    break;
  default:
    break;
  }
}