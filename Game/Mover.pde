
PVector gravityForce = new PVector(0, 0);
float frictionMagnitude = normalForce * mu;


class Mover {

  Mover() {
  }
  
  float clampAngle(float angle){
    if(angle < -PI/3.0) return -PI/3.0;
    if(angle > PI/3.0) return PI/3.0;
    return angle;
  }
  // update() modifies the physical forces at work according to the inclination of the board and the speed of the ball
  void update(PVector rotation) {
    
    
    currZIncline = clampAngle(rotation.y);
    currXIncline = clampAngle(-rotation.x);
    gravityForce.x =  sin(currZIncline) * gravityConstant; 
    gravityForce.y = - sin(currXIncline) * gravityConstant;
    PVector friction = sphereVelocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    sphereVelocity.add(gravityForce).add(friction);
    spherePositionFromCenter.add(sphereVelocity);
  }
  
  // checkCollisions() checks to see if any velocities or positions need to be modified because of a collision
  void checkCollisions() {
    checkEdges();
    checkCylinderCollisions();
  }
  
  // checkEdges() checks to see if any velocities or positions need to be modified because of a collision between the ball and the box edges
  void checkEdges() {
    boolean collision = false;
    if (Math.abs(spherePositionFromCenter.x) > boxWidth/2 - sphereSize) {
      sphereVelocity.x = -sphereVelocity.x*elasticity;
      if (spherePositionFromCenter.x > boxWidth/2 - sphereSize) {
        spherePositionFromCenter.x = boxWidth/2 - sphereSize;
      } else {
        spherePositionFromCenter.x = -boxWidth/2 + sphereSize;
      }
      collision = true;
    }
    if (Math.abs(spherePositionFromCenter.y) > boxDepth/2 - sphereSize) {
      sphereVelocity.y = -sphereVelocity.y*elasticity;
      if (spherePositionFromCenter.y > boxDepth/2 - sphereSize) {
        spherePositionFromCenter.y = boxDepth/2 - sphereSize;
      } else {
        spherePositionFromCenter.y = -boxDepth/2 +sphereSize;
      }
      collision = true;

    }
    if (collision && sphereVelocity.mag()> minVelocityForScore){
      playSound(banana);
      lastScore = -sphereVelocity.mag();
      totalScore += lastScore;
      updateMaxMinScore();
    }
    
  }


  // checkCylinderCollisions() checks to see if any velocities or positions need to be modified because of a collision between the ball and a cylinder 
  void checkCylinderCollisions() {

    for (int i=0; i<cylinders.size(); i++) {
      float distance = cylinderPositions.get(i).dist(spherePositionFromCenter);
      if (distance <= sphereSize + cylinderBaseSize) {
        playSound(giggle);
        PVector normalVector = PVector.sub(spherePositionFromCenter, cylinderPositions.get(i)).normalize();
        spherePositionFromCenter = PVector.add(cylinderPositions.get(i), PVector.mult(normalVector, cylinderBaseSize+sphereSize));
        sphereVelocity = PVector.sub(sphereVelocity, PVector.mult(normalVector, 2*normalVector.dot(sphereVelocity)));
        sphereVelocity.mult(elasticity);
        if (sphereVelocity.mag()>minVelocityForScore){
          lastScore = sphereVelocity.mag();
          totalScore += lastScore;
          updateMaxMinScore();
        }
      }
    }
  }
}