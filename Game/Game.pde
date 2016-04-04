float rotationX = 0f, rotationY = 0f, rotationZ = 0f;
float saveRX = 0, saveRY = 0, saveRZ = 0;
float rtS = 0.01, multipRTS = 1, addedMRTS = 0.2, maxMRTS = 5, minMRTS = 0.2; //rotation Speed
//W for Width, T for Thickness, D for Depth
float boxW, boxT, boxD, sphereR;
float addedAngle = PI/32;
float zoom = 0, zoomAdd = 50, zoomMax = 300;
boolean camera = true;

Mover mover;
Utils toolbox;
Drawer draw;


void settings() {
size(1000, 1000, P3D);
}
void setup() {
noStroke();
mover = new Mover();
toolbox = new Utils();
draw = new Drawer();
boxW = 600;
boxD = 600; 
boxT = 10;
sphereR = 25;
//camera(width/2.0, - height/8.0, (height/4.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
}

void draw(){
 
  //y = height/2.0  -300
  //x = width/2.0 -500
 
pushMatrix();
translate(width/2, height/2, 0);

if(camera){
camera(0, -600 - zoom, 600 + zoom, 0, 0, 0, 0, -0.2, 1);


}
else{
camera(0, -900 - zoom, 1, 0, 0, 0, 0, 1, 0);

}

background(0);
stroke(5);
fill(255, 255, 0);
rotateX(rotationX);
rotateY(rotationY);
rotateZ(rotationZ);
box(boxW, boxT, boxD);

draw.walls();

pushMatrix();
translate(0,-5, 0);
fill(0);
noStroke();
box(5, 0.5 , 30);
box(30, 0.5 , 5);
popMatrix();


mover.update();
mover.checkEdges();
        pushMatrix();
        translate(0, -30, 0);
            pushMatrix();
            
            translate(mover.location.x, mover.location.y, mover.location.z);
            stroke(255);
            sphere(sphereR);
            popMatrix();        
        popMatrix();
popMatrix();

}

void mouseWheel(MouseEvent event){
float e = event.getCount();
multipRTS = toolbox.clamp(multipRTS + ((e > 0) ? -1 : 1) * addedMRTS, minMRTS, maxMRTS);
}


void mouseDragged(){
  float xDiff = mouseX - pmouseX;
  float yDiff = mouseY - pmouseY;
  map(xDiff,-1000, 1000, -PI/16, PI/16);
  map(yDiff,-1000, 1000, -PI/16, PI/16);
  
  if(camera) rotationY = toolbox.clampAngle(rotationY + ((rtS * multipRTS) *xDiff));

  if(camera) rotationX = toolbox.clampAngle(rotationX + (-(rtS * multipRTS) *yDiff));
}

void switchCameras(){
if(camera){
saveRX = rotationX;
saveRY = rotationY;
saveRZ = rotationZ;
rotationX = 0;
rotationY = 0;
rotationZ = 0;
camera = false;

}

else{
rotationX = saveRX;
rotationY = saveRY;
rotationZ = saveRZ;
camera = true;
}
}

void keyPressed(){
     
    switch(key){
    case 'a' : if(camera) rotationZ = toolbox.clampAngle(rotationZ - addedAngle); break;
    case 'd' : if(camera) rotationZ = toolbox.clampAngle(rotationZ + addedAngle); break;
    case 'w' : if(camera) rotationX = toolbox.clampAngle(rotationX + addedAngle); break;
    case 's' : if(camera) rotationX = toolbox.clampAngle(rotationX - addedAngle); break;
    case 'q' : if(camera) rotationY = toolbox.clampAngle(rotationY - addedAngle); break;
    case 'e' : if(camera) rotationY = toolbox.clampAngle(rotationY + addedAngle); break;
    case 'y' : zoom = toolbox.clamp(zoom + zoomAdd, - zoomMax, zoomMax); break;
    case 'x' : zoom = toolbox.clamp(zoom - zoomAdd, - zoomMax, zoomMax); break;
    case 'c' : switchCameras();
    default: ;
    }
    
  
}