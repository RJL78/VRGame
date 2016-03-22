

class Plate {
  float rx, rz;
  void Plate()  {
    rx=0;
    rz=0;
  }
  void update() {
    rx = map(mY, 0, height, -PI/6, PI/6);
    rz = map(mX, 0, width, -PI/6, PI/6);
    rotateX(rx);
    rotateZ(rz);
    box(150, 5, 150);
  }
  
  float getRX(){
    return rx;
  }
  
  float getRZ(){
    return rz;
  }
  
  float getSize(){
    return 150;
  }
}