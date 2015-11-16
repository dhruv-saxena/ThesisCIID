class Person {

  //Physics stuff
  PVector location;
  PVector velocity;
  PVector acceleration;

  float r;
  float maxforce;
  float maxspeed;

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

    maxspeed = 4;
    maxforce = 0.1;
    r=10;

    name = n;
    places = new ArrayList<String>();
    cordinates = new ArrayList<PVector>();
    month = new IntList();
    year = new IntList();
  }


  void display() {
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

    PVector steerforce = PVector.sub(desired, velocity);
    
    //This if statement adds a bit of randomness to the person's path. 
    //Increase x to reduce randomness, in (d>x)
    if(d>5){
    PVector random = new PVector(random(-5,5),random(-5,5));
    steerforce.add(random);
    }
    
    steerforce.limit(maxforce);
    applyForce(steerforce);
  }
}

