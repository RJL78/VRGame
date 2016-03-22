class Mover {
  PVector location;
  PVector velocity;
  PVector gravityForce;
  PVector friction;
  float gravityConstant = 0.8;
  float radius;
  float elasticity = 0.8;
  Plate plate;

  Mover(Plate p,float r) {
    plate = p;
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
    radius =r;
  }

  void drawSphere() {
    pushMatrix();
    translate(location.x,location.y,location.z);
    sphere(radius);    
    popMatrix();
  }

  void moveBall() {
    gravityForce.x = sin(plate.getRZ()) * gravityConstant;
    gravityForce.z = sin(-plate.getRX()) * gravityConstant;
   // println("The location is" + plate.getRX() + " , "+location.y+" ,"+gravityForce.z);

    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    friction.x=velocity.x;
    friction.y=velocity.y;
    friction.z=velocity.z;
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    velocity.add(gravityForce).add(friction);
    location.add(velocity);
  }
  
  void checkedges(){
    if (location.x>plate.getSize()/2.0) {
      location.x = plate.getSize()/2.0;
      velocity.x = -velocity.x*elasticity ;
    }
    if (location.x<-plate.getSize()/2.0) {
      location.x = -plate.getSize()/2.0;
      velocity.x = -velocity.x*elasticity ;
    }
    if (location.z>plate.getSize()/2.0) {
      location.z = plate.getSize()/2.0;
      velocity.z = -velocity.z*elasticity ;
    }
    if (location.z<-plate.getSize()/2.0) {
      location.z = -plate.getSize()/2.0;
      velocity.z = -velocity.z*elasticity ;
    }
    
  }
}
