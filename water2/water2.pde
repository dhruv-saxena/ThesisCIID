/*
Feature List
1. All creatures have arrival and separation behaviors
2. Mercarator Map
3. Water
4. Database
5. Trail
6. life - comment out p.alive = false in getPlace() to not kill.
7. optimised - variable in functions tab
8. do not distrub if person is within 3 units of target
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


void setup() {

  //size(1440, 900,FX2D);
  //size(720, 450,P2D);// Use fullScreen mode, FX2D can create strange offsets when size is defined.
  fullScreen(FX2D);
  
  frameRate(60);
  noStroke();  
  
  land = loadImage("landShadow2.png");
  water = loadImage("water1.jpg");
  mercatorMap = new MercatorMap(width, height,80,-58,-529.45+360,-167.34+360);
  //mercatorMap = new MercatorMap(856, 500,80,-58,-529.45+360,-167.34+360);
  
  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(6, 2014);

  getPlace(); //get places based on starting time
  
  waterSetup();  //Setup water variables
  smooth();
}

void draw() {
  background(255);
  image(water, 0, 0, width, height);
  image(land, 0, 0, width, height);
  waterDraw();
  movePersons();
 
  
}

void keyPressed() {
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

void mousePressed(){
   home = !home;
}