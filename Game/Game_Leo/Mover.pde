class Mover{
PVector location;
PVector velocity;
PVector gravity;
PVector ff; //friction force
float rawSpeed;

final float gravityConstant = .05 * 3;
final float nl = .8; //nL stands for normal loss
final float fmu = 0.01;


Mover() {
location = new PVector(0, 0, 0);
velocity = new PVector(0, 0, 0);
gravity = new PVector(0, 5, 0);
}

void update() {
location.add(velocity);
rawSpeed = velocity.mag();
velocity.add(totalF());


}

float limitX(){
return (boxW/2 - sphereR) /* *cos(rotationZ)*/;
}

float limitZ(){
return (boxD/2 - sphereR);
}

//TODO: correct these
PVector gravity(){
return new PVector(sin(rotationZ) * gravityConstant,
            gravityConstant,
            sin(-rotationX) * gravityConstant);
}

PVector friction(){
PVector result = velocity.copy();
result.normalize().mult(-fmu * rawSpeed);
return result;
}

PVector totalF(){
return gravity().add(friction());
}


void checkEdges() {
if (location.x > limitX()) {
  location.x = limitX();
  velocity.x *= - nl;
}
else if (location.x < - limitX()) {
  location.x = - limitX();
  velocity.x *= - nl;
}

if (location.z > limitZ()) {
  location.z = limitZ();
  velocity.z *= - nl;
}
else if (location.z < - limitZ()) {
  location.z = - limitZ();
  velocity.z *= - nl;
}

if (location.y > 0) {
  location.y = 0;
//velocity.y /= -5;
}
}

}