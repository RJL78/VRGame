//float eyeX, eyeY, eyeZ;
//float ang = 0;
//int d = 200;
//// -----------------------------------------------------------------
//void settings() {
//    size(1000, 600, P3D);

//}


//void setup() {
//  eyeX = width/2;
//  eyeY = height/2;
//  eyeZ = d;
//}
//// -----------------------------------------------------------------
//void draw() {
//  // background in the draw loop to make it animate rather than draw over itself
//  background(0);
//  lights();
//  stroke(255);
 
//  // CAMERA:
//  if (eyeZ<0)
//    camera(eyeX, eyeY, eyeZ, 
//    width/2, height/2, 0, 
//    0, -1, 0);
//  else
//    camera(eyeX, eyeY, eyeZ, 
//    width/2, height/2, 0, 
//    0, 1, 0);
 
//  pushMatrix();
//  translate(width/2, height/2, 0);
//  fill(255);
//  box(100);
//  popMatrix();
 
//  pushMatrix();
//  translate(width/2-50, height/2-50, 0);
//  fill(255, 0, 0);
//  box(10);
//  popMatrix();
//}
 
//// -----------------------------------------------------------------
 
//void keyPressed() {
//  switch(key) {
//    // Move camera
//  case CODED:
//    if (keyCode == UP) {
//      ang += 5;
//    }
//    if (keyCode == DOWN) {
//      ang -= 5;
//    }
//    break;
 
//  default:
//    // !CODED:
//    break;
//  } // switch
 
//  if (ang>=360)
//    ang=0;
//  eyeY = (height/2)-d*(sin(radians(ang)));
//  eyeZ = d*cos(radians(ang));
//  println("Angle "+ang+": "+eyeX+" / "+eyeY+" / "+eyeZ);
//}