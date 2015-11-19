class Person {

  //Physics stuff
  PVector location;
  PVector velocity;
  PVector acceleration;

  float r;
  float maxforce;
  float maxspeed;
  
  float steerForceFactor = 1; //Weights of steer and separate counter each other. 1 and 1.01 is the best combo.
  float separateForceFactor = 1.01;

  //Maybe use mass and colour 
  float mass;
  String colour;

  //DB stuff
  String name;
  ArrayList<String> places;
  ArrayList<PVector> cordinates; 
  IntList month;
  IntList year;

  //Holds long and lat values of only the relevant index according to time.
  //Calculated in getPlace(), and then used in movePersons()
  PVector targetMap;
  PVector home; 

  Person(String n, float hx, float hy) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(width/2, height/2);
    targetMap = new PVector(hx, hy);//Start the sketch with home countries if time is less than the first time of the person.
    home = new PVector(hx,hy);

    maxspeed = 6;
    maxforce = 0.6;
    r=10;

    name = n;
    places = new ArrayList<String>();
    cordinates = new ArrayList<PVector>();
    month = new IntList();
    year = new IntList();
  }


  void display() {
      fill(100);
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

    PVector steerForce = PVector.sub(desired, velocity);
    
    //This if statement adds a bit of randomness to the person's path. 
    //Increase x to reduce randomness, in (d>x)
    if(d>15){
    PVector random = new PVector(random(-5,5),random(-5,5));
    steerForce.add(random);
    }
    
    steerForce.limit(maxforce);
    steerForce.mult(steerForceFactor);
    applyForce(steerForce);
  }
  
    // Separation
  // Method checks for nearby vehicles and steers away
  void separate (ArrayList<Person> persons) {
    float desiredseparation = r;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Person other : persons) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
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