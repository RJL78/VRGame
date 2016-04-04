class Drawer{

  void walls(){
  pushMatrix();
  fill(255);
  
  translate(boxW/2 + 10, -10, 0);
  box(20, 30, boxD);
  translate(0, 0, boxD/2 + 10);
  box(20, 30, 20);
  
  translate(-boxW/2 - 10, 0, 0);
  box(boxW, 30, 20);
  translate(-boxW/2 - 10, 0, 0);
  box(20, 30, 20);
  
  translate(0, 0, -boxD/2 - 10);
  box(20, 30, boxD);
  translate(0, 0, -boxD/2 - 10);
  box(20, 30, 20);
  
  translate(boxW/2 + 10, 0, 0);
  box(boxW, 30, 20);
  translate(boxW/2 + 10, 0, 0);
  box(20, 30, 20);
  
  popMatrix();
}

}