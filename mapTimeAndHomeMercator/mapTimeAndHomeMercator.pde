PImage worldMapImage;
MercatorMap mercatorMap;


//Timeline, table, persons 
Scrub s;
Table table;
ArrayList<Person> persons;

//This will be set based on a home token.
boolean home =false;


void setup() {

  size(720, 450,P2D);
  //fullScreen(P2D);
  smooth();
  noStroke();
  
  worldMapImage = loadImage("world.png");
  mercatorMap = new MercatorMap(width, height,80,-58,-529.45+360,-167.34+360);
  //mercatorMap = new MercatorMap(856, 500,80,-58,-529.45+360,-167.34+360);
  
  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(6, 2014);


  getPlace(); //get places based on starting time
}

void draw() {
  background(255);
  image(worldMapImage, 0, 0, width, height);
  
  movePersons();
}

void keyPressed() {
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