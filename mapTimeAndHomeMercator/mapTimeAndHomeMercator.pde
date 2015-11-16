PImage worldMapImage;
MercatorMap mercatorMap;


//Timeline, table, persons 
Scrub s;
Table table;
ArrayList<Person> persons;

//This will be set based on a home token.
boolean home =false;


void setup() {

  size(4281/5, 2502/5,P2D);
  smooth();
  
  worldMapImage = loadImage("world.png");
  mercatorMap = new MercatorMap(4281/5, 2502/5,80,-58,-529.45+360,-167.34+360);
  
  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(6, 2014);


  getPlace(); //get places based on starting time
}

void draw() {
  background(255);
  image(worldMapImage, 0, 0, width, height);
  
  fill(255);
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

