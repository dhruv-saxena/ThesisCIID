class Blob {


  PVector location;
  PVector velocity;
  PVector acceleration;

  float r;
  float maxforce;
  float maxspeed;

  float steerForceFactor = .75; //Weights of steer and separate counter each other. 1.05 and 1.0 is the best combo.
  float separateForceFactor = 1.5;

  float mass;
  String colour;
  boolean alive = true;


  Blob() {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(width/2, height/2);

    mass = 200;

    maxspeed = 6;
    maxforce = 4;
    r= mass; //r is actually the diameter, not the radius

    
  }

  void display() {
    fill(0, 0, 0, 100);
    ellipse(location.x, location.y, r/30, r/30);
    ellipse(location.x, location.y, r, r);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    force.div(mass);
    force.mult(40);
    acceleration.add(force);
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();
    if (d<200) {
      float m = map(d, 0, 200, 0, maxspeed);
      desired.setMag(m);
    } else {
      desired.limit(maxspeed);
    }

    PVector steerForce = PVector.sub(desired, velocity);

    //This if statement adds a bit of randomness to the person's path. 
    //Increase x to reduce randomness, in (d>x)
    //if (d>15) {
    //  PVector random = new PVector(random(-5, 5), random(-5, 5));
    //  steerForce.add(random);
    //}

    steerForce.limit(maxforce);
    steerForce.mult(steerForceFactor);
    applyForce(steerForce);
  }

  // Separation
  // Method checks for nearby vehicles and steers away
  void separate (ArrayList<Person> persons) {

    PVector sum = new PVector();
    int count = 0;
    // For every blob in the system, check if it's too close
    for (Person other : persons) {
      float desiredseparation;

      if (other.active) {//check if the rfid token for the person is there.
        desiredseparation = (r+other.blob.r)/2;  

        float d = PVector.dist(location, other.blob.location);
        // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
        if ((d > 0) && (d < desiredseparation)) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(location, other.blob.location);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
        }
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    PVector separateForce = sum; 
    separateForce.mult(separateForceFactor);
    applyForce(separateForce);
  }
}