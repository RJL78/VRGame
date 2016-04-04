

class Plate {
  float rx, rz, pWidth, pSize;
  float i=0;
  Plate(float pSize, float pWidth)  {
    rx=0;
    rz=0;
    this.pWidth=pWidth;
    this.pSize=pSize;
  }
  void update() {
    pushMatrix();
    translate(width/2, height/2, 0);
    rx = map(mY, 0, height, -PI/6, PI/6);
    rz = map(mX, 0, width, -PI/6, PI/6);
    rotateX(rx);
    rotateZ(rz);
    fill(196, 240, 200);
    box(pSize, pWidth, pSize);
    stroke(50);
    line(0,0,0,0,-height/2,0);
    popMatrix();
  }

  void getCamAbove() {
   float eyeX = (height/2)*(sin(rz)+1);
   float eyeY = (height/2)*(1-cos(rz)*cos(rx));
   float eyeZ = (height/2)*sin(-rx)*cos(rz);
   camera(eyeX,eyeY,eyeZ,width/2,height/2,0,0,0,1);
}

  float getRX() {
    return rx;
  }

  float getRZ() {
    return rz;
  }

  float getSize() {
    return pSize;
  }

  float getWidth() {
    return pWidth;
  }
}