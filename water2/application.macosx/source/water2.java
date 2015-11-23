import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class water2 extends PApplet {

/*
Feature List
1. All creatures have arrival and separation behaviors
2. Mercarator Map
3. Water
4. Database
5. Trail
6. life - comment out p.alive = false in getPlace() to not kill.
*/

PImage land;
PImage water;
MercatorMap mercatorMap;


//Timeline, table, persons 
Scrub s;
Table table;
ArrayList<Person> persons;

//This will be set based on a home token.
boolean home =false;

//Water Simulation Variables
int size;
int hwidth,hheight;
int riprad;

int ripplemap[];
int ripple[];
int texture[];

int oldind,newind, mapind;
int i,a,b; 


public void setup() {

  
  //size(720, 450,P2D);// Use fullScreen mode, FX2D can create strange offsets when size is defined.
  //fullScreen(P2D);
  
  frameRate(60);
  noStroke();  
  
  land = loadImage("landShadow2.png");
  water = loadImage("water1.jpg");
  mercatorMap = new MercatorMap(width, height,80,-58,-529.45f+360,-167.34f+360);
  //mercatorMap = new MercatorMap(856, 500,80,-58,-529.45+360,-167.34+360);
  
  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(6, 2014);

  getPlace(); //get places based on starting time
  
  waterSetup();  //Setup water variables
  
}

public void draw() {
  background(0,0,255);
  
  waterDraw();
  movePersons();
  println(width,height);
  
}

public void keyPressed() {
  //KeyPressed does not work with FX2D, change back to P2D in case need keyboard to work
  println(s.month + "/" +s.year);
  getPlace();

  if (key == 'q') {
    s.increase();
  } else if (key == 'w') {
    s.decrease();
  } else if (key== 'h' ) {
    home = !home;
  }
}

public void mousePressed(){
   home = !home;
}
/**
 * Utility class to convert between geo-locations and Cartesian screen coordinates.
 * Can be used with a bounding box defining the map section.
 *
 * (c) 2011 Till Nagel, tillnagel.com
 */
public class MercatorMap {
  
  public static final float DEFAULT_TOP_LATITUDE = 80;
  public static final float DEFAULT_BOTTOM_LATITUDE = -80;
  public static final float DEFAULT_LEFT_LONGITUDE = -180;
  public static final float DEFAULT_RIGHT_LONGITUDE = 180;
  
  /** Horizontal dimension of this map, in pixels. */
  protected float mapScreenWidth;
  /** Vertical dimension of this map, in pixels. */
  protected float mapScreenHeight;

  /** Northern border of this map, in degrees. */
  protected float topLatitude;
  /** Southern border of this map, in degrees. */
  protected float bottomLatitude;
  /** Western border of this map, in degrees. */
  protected float leftLongitude;
  /** Eastern border of this map, in degrees. */
  protected float rightLongitude;

  private float topLatitudeRelative;
  private float bottomLatitudeRelative;
  private float leftLongitudeRadians;
  private float rightLongitudeRadians;

  public MercatorMap(float mapScreenWidth, float mapScreenHeight) {
    this(mapScreenWidth, mapScreenHeight, DEFAULT_TOP_LATITUDE, DEFAULT_BOTTOM_LATITUDE, DEFAULT_LEFT_LONGITUDE, DEFAULT_RIGHT_LONGITUDE);
  }
  
  /**
   * Creates a new MercatorMap with dimensions and bounding box to convert between geo-locations and screen coordinates.
   *
   * @param mapScreenWidth Horizontal dimension of this map, in pixels.
   * @param mapScreenHeight Vertical dimension of this map, in pixels.
   * @param topLatitude Northern border of this map, in degrees.
   * @param bottomLatitude Southern border of this map, in degrees.
   * @param leftLongitude Western border of this map, in degrees.
   * @param rightLongitude Eastern border of this map, in degrees.
   */
  public MercatorMap(float mapScreenWidth, float mapScreenHeight, float topLatitude, float bottomLatitude, float leftLongitude, float rightLongitude) {
    this.mapScreenWidth = mapScreenWidth;
    this.mapScreenHeight = mapScreenHeight;
    this.topLatitude = topLatitude;
    this.bottomLatitude = bottomLatitude;
    this.leftLongitude = leftLongitude;
    this.rightLongitude = rightLongitude;

    this.topLatitudeRelative = getScreenYRelative(topLatitude);
    this.bottomLatitudeRelative = getScreenYRelative(bottomLatitude);
    this.leftLongitudeRadians = getRadians(leftLongitude);
    this.rightLongitudeRadians = getRadians(rightLongitude);
  }

  /**
   * Projects the geo location to Cartesian coordinates, using the Mercator projection.
   *
   * @param geoLocation Geo location with (latitude, longitude) in degrees.
   * @returns The screen coordinates with (x, y).
   */
  public PVector getScreenLocation(PVector geoLocation) {
    float latitudeInDegrees = geoLocation.x;
    float longitudeInDegrees = geoLocation.y;

    return new PVector(getScreenX(longitudeInDegrees), getScreenY(latitudeInDegrees));
  }

  private float getScreenYRelative(float latitudeInDegrees) {
    return log(tan(latitudeInDegrees / 360f * PI + PI / 4));
  }

  protected float getScreenY(float latitudeInDegrees) {
    return mapScreenHeight * (getScreenYRelative(latitudeInDegrees) - topLatitudeRelative) / (bottomLatitudeRelative - topLatitudeRelative);
  }
  
  private float getRadians(float deg) {
    return deg * PI / 180;
  }

  protected float getScreenX(float longitudeInDegrees) {
    float longitudeInRadians = getRadians(longitudeInDegrees);
    return mapScreenWidth * (longitudeInRadians - leftLongitudeRadians) / (rightLongitudeRadians - leftLongitudeRadians);
  }
}
class Person {

  //Physics stuff
  ArrayList<PVector> points;
  PVector location;
  PVector velocity;
  PVector acceleration;

  float r;
  float maxforce;
  float maxspeed;

  float steerForceFactor = 1.05f; //Weights of steer and separate counter each other. 1.05 and 1.0 is the best combo.
  float separateForceFactor = 1.0f;

  //Maybe use mass and colour 
  float mass;
  String colour;
  boolean alive = true;
  float textSize; 

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
  PVector target; //Final target, be it home or the location acc to scrub

  Person(String n, float hx, float hy) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(width/2, height/2);
    targetMap = new PVector(hx, hy);//Start the sketch with home countries if time is less than the first time of the person.
    home = new PVector(hx, hy);
    target = new PVector(0, 0);//Does not matter what values you give. Just initialising.

    mass = random(8, 15);
    textSize = mass*2/3;

    maxspeed = 8;
    maxforce = 1;
    r= mass; //r is actually the diameter, not the radius

    points = new ArrayList<PVector>();

    name = n;
    places = new ArrayList<String>();
    cordinates = new ArrayList<PVector>();
    month = new IntList();
    year = new IntList();
  }


  public void display() {
    fill(0xffADC70F, 150);
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


  public void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  public void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    force.div(mass).mult(10);;
    acceleration.add(force);
  }

  public void arrive(PVector target) {
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
    if (d>15) {
      PVector random = new PVector(random(-5, 5), random(-5, 5));
      steerForce.add(random);
    }

    steerForce.limit(maxforce);
    steerForce.mult(steerForceFactor);
    applyForce(steerForce);
  }

  // Separation
  // Method checks for nearby vehicles and steers away
  public void separate (ArrayList<Person> persons) {

    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Person other : persons) {
      float desiredseparation;
      
      if(other.alive)
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

  public void pointTrail(ArrayList<PVector> points) {
    if (points.size()>r) {
      points.remove(0);
    }
    points.add(new PVector(location.x, location.y));
  }
}
class Scrub {

  int month;
  int year;

  Scrub() {
    month = month();
    year = year();
  }

    Scrub(int m, int y) {
    month = m;
    year = y;
  }

  public void increase() {
    if (month>=12) {
      month=1;
      year+=1;
    } else
      month+=1;
  }

  public void decrease() {
    if (month<=1) {
      month=12;
      year-=1;
    } else
      month-=1;
  }
}
//Load data from DB into persons arraylist. This function should remain same in next versions.
//The function solely pertains to DB, and nothing else.
//The function is called in the setup, and would be called in the setup of all sketches further on.
public void loadData() {
  table = loadTable("data.csv", "header");

  for (int i=0; i<table.getRowCount (); i++) {
    TableRow row = table.getRow(i);
    // You can access the fields via their column name (or index)
    String name = row.getString("name");
    float homeX = row.getFloat("homeX");
    float homeY = row.getFloat("homeY");


    if (name.equals("")==false) //Only when name is non empty i.e when a name is present
      persons.add(new Person(name, homeX, homeY)); //Add Person with name and home city cordinates

    Person p =  persons.get(persons.size()-1); //Get last person in list i.e the one just added
    p.places.add(row.getString("place")); //Add place, month and year to this person
    p.month.append(row.getInt("month")); //The addition keeps happening for the whole for loop
    p.year.append(row.getInt("year")); //So unless a new person is detected, keep adding place, month and year to the last person

    //Also adding co-ordinates
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    p.cordinates.add(new PVector(x, y));
  }
}

//Get place according to time for each person. This function should remain same in next versions.
//The function attends to time and based on it sets the targetMap variable for each person.
//The function is only called when there is a change in time. In this case detected by a keypress.
public void getPlace() {

  //iterate over each person
  for (int i=0; i<persons.size (); i++) {
    Person p = persons.get(i);
    println(p.name);

    //get the right place index according to time
    int index = -1;
    for (int k=0; k<p.year.size (); k++) {
      if (s.year > p.year.get(k)) {
        index = k;
      } else if (s.year == p.year.get(k)) {
        if (s.month >= p.month.get(k))
          index = k;
      }
    }
    if (index>-1) {    
      p.alive = true; // can remove if not killing
      p.targetMap = p.cordinates.get(index); 
      println(p.places.get(index) + " X: " + p.targetMap.x + " Y: " + p.targetMap.y); //here you can do what you need with the place
    } else{
      p.targetMap = p.home;
      //p.alive = false; // this is the statement alone responsible for killing. Remove this to not kill.
    }
  }
}

//This function is responsible for the movement of persons.
// The only thing that you might need to replace is you create your own map is the "ScreenPosition" line.
// You will have to put in your algorithm to get the pixel positions for the lat and long values in targetMap.
//Remember that targetMap is there in every person, and it holds only the relevant lat and long according to scrub.
public void movePersons() {

  for (Person p : persons) {
    if(p.alive){ //can remove if not killing
    
    PVector pos;

    if (home)
      pos = mercatorMap.getScreenLocation(p.home);

    else
      //get the screen position for the relevant lat and long
      pos = mercatorMap.getScreenLocation(p.targetMap);

    p.target = pos;
    p.arrive(p.target);
    p.separate(persons);
    p.update();
    p.display();
    disturb(PApplet.parseInt(p.location.x), PApplet.parseInt(p.location.y));
    }
  }
}

//Water Simulation Functions

public void waterSetup() {
  hwidth = width>>1;
  hheight = height>>1;
  riprad=3; //test with 3

  size = width * (height+2) * 2;

  ripplemap = new int[size];
  ripple = new int[width*height];
  texture = new int[width*height];

  oldind = width;
  newind = width * (height+3);
}
// Whatever needs to go in draw
public void waterDraw() {
  image(water, 0, 0, width, height);
  loadPixels();
  texture = pixels;

  newframe();

  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = ripple[i];
  }

  updatePixels();
  ellipse(0, 0, 0, 0); //a bug, the next image does not render without this line.
  image(land, 0, 0, width, height);
}


public void disturb(int dx, int dy) {
  for (int j=dy-riprad; j<dy+riprad; j++) {
    for (int k=dx-riprad; k<dx+riprad; k++) {
      if (j>=0 && j<height && k>=0 && k<width) {
        ripplemap[oldind+(j*width)+k] += 1024;   //test with 512
      }
    }
  }
}

//The next 2 functions below are a part of the algorithm
public void newframe() {
  //Toggle maps each frame
  i=oldind;
  oldind=newind;
  newind=i;

  i=0;
  mapind=oldind;
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {
      short data = (short)((ripplemap[mapind-width]+ripplemap[mapind+width]+ripplemap[mapind-1]+ripplemap[mapind+1])>>1);
      data -= ripplemap[newind+i];
      data -= data >> 5;
      ripplemap[newind+i]=data;

      //where data=0 then still, where data>0 then wave
      data = (short)(1024-data);

      //offsets
      a=((x-hwidth)*data/1024)+hwidth;
      b=((y-hheight)*data/1024)+hheight;

      //bounds check
      if (a>=width) a=width-1;
      if (a<0) a=0;
      if (b>=height) b=height-1;
      if (b<0) b=0;

      ripple[i]=texture[a+(b*width)];
      mapind++;
      i++;
    }
  }
}
  public void settings() {  size(1440, 900,FX2D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "water2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
