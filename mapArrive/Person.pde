class Person {

  PVector location;
  PVector velocity;
  PVector acceleration;

  float r;
  float maxforce;
  float maxspeed;

  float time;
  float mass;
  String colour;

  Person(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);

    maxspeed = 4;
    maxforce = 0.1;
  }

  void seekTarget() {
  }

  void display() {
    ellipse(location.x,location.y,10,10);
  }
  

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();
    if (d<100) {
      float m = map(d, 0, 100, 0, maxspeed);
      desired.setMag(m);
    } else {
      desired.limit(maxspeed);
    }

    PVector steerforce = PVector.sub(desired, velocity);
    steerforce.limit(maxforce);
    applyForce(steerforce);
  }
}