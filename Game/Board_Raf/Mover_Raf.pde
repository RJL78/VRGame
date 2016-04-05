PVector gravityForce = new PVector(0, 0);
float frictionMagnitude = normalForce * mu;

class Mover {

  Mover() {
  }

  void update() {
    gravityForce.x =  sin(currZIncline) * gravityConstant;
    gravityForce.y = - sin(currXIncline) * gravityConstant;

    PVector friction = sphereVelocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    sphereVelocity.add(gravityForce).add(friction);
    spherePositionFromCenter.add(sphereVelocity);
  }
  void checkCollisions() {
    checkEdges();
    checkCylinderCollisions();
  }
  void checkEdges() {
    if (Math.abs(spherePositionFromCenter.x) > boxWidth/2 - sphereSize) {
      sphereVelocity.x = -sphereVelocity.x*elasticity;
      if (spherePositionFromCenter.x > boxWidth/2 - sphereSize){
         spherePositionFromCenter.x = boxWidth/2 - sphereSize;
      }
      else {
        spherePositionFromCenter.x = -boxWidth/2 + sphereSize;
      }
    }
    if (Math.abs(spherePositionFromCenter.y) > boxDepth/2 - sphereSize) {
      sphereVelocity.y = -sphereVelocity.y*elasticity;
      if (spherePositionFromCenter.y > boxDepth/2 - sphereSize){
         spherePositionFromCenter.y = boxDepth/2 - sphereSize;
      }
      else {
        spherePositionFromCenter.y = -boxDepth/2 +sphereSize;
      }
    }
  }
  int j = 0;
  void checkCylinderCollisions() {
   for (int i=0; i<cylinders.size();i++) {
     float distance = cylinderPositions.get(i).dist(spherePositionFromCenter);
     if (distance <= sphereSize + cylinderBaseSize) {
       PVector normalVector = PVector.sub(spherePositionFromCenter,cylinderPositions.get(i)).normalize();
       spherePositionFromCenter = PVector.add(cylinderPositions.get(i),PVector.mult(normalVector,cylinderBaseSize+sphereSize));
       sphereVelocity = PVector.sub(sphereVelocity,PVector.mult(normalVector,2*normalVector.dot(sphereVelocity)));
       sphereVelocity.mult(elasticity);  
     } 
   }
  }
  
}
