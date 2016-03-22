float e = 1;
float mY = 500/2;
float mX = 500/2;
Mover mover;
Plate plate;

void settings() {
  size(500, 500, P3D);
}

void setup() {
  noStroke();
  plate = new Plate();
  mover = new Mover(plate,10);

}

void draw() {
  camera(width/2, height/2, 250, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  plate.update();
  translate(0,-12.5,0);
  mover.moveBall();
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