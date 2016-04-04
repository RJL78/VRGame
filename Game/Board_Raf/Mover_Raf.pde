
PVector gravityForce = new PVector(0, 0, 0);
float frictionMagnitude = normalForce * mu;

class Mover {

  Mover() {
  }

  void update() {
    gravityForce.x =  sin(currZIncline) * gravityConstant;
    gravityForce.z = - sin(currXIncline) * gravityConstant;

    PVector friction = sphereVelocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    sphereVelocity.add(gravityForce).add(friction);
    spherePositionFromCenter.add(sphereVelocity);
  }
  // ADD CYCLINDER COLLISIONS
  void checkEdges() {
    if (Math.abs(spherePositionFromCenter.x) > boxWidth/2 - sphereSize) {
      sphereVelocity.x = -sphereVelocity.x;
      if (spherePositionFromCenter.x > boxWidth/2 - sphereSize){
         spherePositionFromCenter.x = boxWidth/2 - sphereSize;
      }
      else {
        spherePositionFromCenter.x = -boxWidth/2 + sphereSize;
      }
    }
    if (Math.abs(spherePositionFromCenter.z) > boxDepth/2 - sphereSize) {
      sphereVelocity.z = -sphereVelocity.z;
      if (spherePositionFromCenter.z > boxDepth/2 - sphereSize){
         spherePositionFromCenter.z = boxDepth/2 - sphereSize;
      }
      else {
        spherePositionFromCenter.z = -boxDepth/2 +sphereSize;
      }
    }
  }
}