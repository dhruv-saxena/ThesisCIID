class Person {

  //Physics stuff
  ArrayList<PVector> points;
  PVector location;
  PVector velocity;
  PVector acceleration;

  Blob blob;


  float r;
  float maxforce;
  float maxspeed;

  float steerForceFactor = 1.05; //Weights of steer and separate counter each other. 1.05 and 1.0 is the best combo.
  float separateForceFactor = 1.0;

  //Maybe use mass and colour 
  float mass;
  String colour;
  boolean alive = true;
  boolean active = true; //rfid token sets this to true or false
  float textSize; 

  //DB stuff
  String name;
  String homeCity;
  String background;
  String batch;
  ArrayList<String> places;
  ArrayList<String> roles;
  ArrayList<String> organisations;
  ArrayList<PVector> cordinates; 
  IntList month;
  IntList year;
  int age;

  //Holds long and lat values of only the relevant index according to time.
  //Calculated in getPlace(), and then used in movePersons()
  PVector targetMap;
  PVector home;
  PVector target; //Final target, be it home or the location acc to scrub

  Person(String n, String h, float hx, float hy, String bcg, String bat) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(width/2, height/2);
    targetMap = new PVector(hx, hy);//Start the sketch with home countries if time is less than the first time of the person.
    home = new PVector(hx, hy);
    target = new PVector(0, 0);//Does not matter what values you give. Just initialising.

    name = n;
    homeCity = h;
    background = bcg;
    batch = bat;
    places = new ArrayList<String>();
    roles = new ArrayList<String>();
    organisations = new ArrayList<String>();
    cordinates = new ArrayList<PVector>();
    month = new IntList();
    year = new IntList();

    String[] batchSplit = splitTokens(batch, "-");
    if (batchSplit.length>0) {
      age = int(batchSplit[batchSplit.length-1]);
      age = year()-2000-age+8;
    }

    mass = age*1.1;
    textSize = mass*2/3;

    maxspeed = 8;
    maxforce = 1;
    r= mass; //r is actually the diameter, not the radius

    points = new ArrayList<PVector>();

    blob = new Blob();
  }


  void display() {
    fill(#ADC70F, 150);
    //ellipse(location.x, location.y, r, r);

    pointTrail(points);
    for (int i=0; i< points.size(); i++) {
      ellipse(points.get(i).x, points.get(i).y, i, i);
    }

    // Added first name initial
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(textSize); 
    text(name.toUpperCase().charAt(0), location.x, location.y);
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
    force.mult(10);

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
    if (d>5) {
      PVector random = new PVector(random(-5, 5), random(-5, 5));
      steerForce.add(random);
    }

    steerForce.limit(maxforce);
    steerForce.mult(steerForceFactor);
    applyForce(steerForce);
  }

  // Separation
  // Method checks for nearby vehicles and steers away
  void separate (ArrayList<Person> persons) {

    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Person other : persons) {
      float desiredseparation;

      if (other.alive)
        desiredseparation = (r+other.r)/2;  
      else
        desiredseparation = 0;  

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

  void pointTrail(ArrayList<PVector> points) {
    if (points.size()>r) {
      points.remove(0);
    }
    points.add(new PVector(location.x, location.y));
  }

  void displayInfo() {
    displayBlob();
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12); 
    text(name, blob.location.x, blob.location.y-50);
    text("Denmark", blob.location.x, blob.location.y-35);
    text("Denmark", blob.location.x, blob.location.y-20);
    text("Denmark", blob.location.x, blob.location.y-5);
  }

  void displayBlob() {

    blob.arrive(location);
    blob.separate(persons);
    blob.update();
    stroke(0, 0, 0, 30);
    noFill();
    line(location.x, location.y, blob.location.x, blob.location.y);
    noStroke();
    blob.display();
    disturb(int(blob.location.x), int(blob.location.y));
  }
}