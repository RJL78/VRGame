
class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  float m = 0.1;
  float g = 9.9;
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(1, 1);
    gravity = new PVector(0,m*g);
  }
  void update() {
    velocity= velocity.add(gravity);
    location.add(velocity);
  }
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }
  void checkEdges() {
    if (location.x > width && velocity.x>0) {
      velocity.x *= -1;
    } else if (location.x < 0 && velocity.x<0) {
      velocity.x *= -1;
    }
    if (location.y > height) {
      velocity.y *= -1;
    } else if (location.y < 0) {
      velocity.y *= -1;
    }
  }
}