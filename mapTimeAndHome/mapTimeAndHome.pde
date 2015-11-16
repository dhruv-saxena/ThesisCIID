import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

//Map instance
UnfoldingMap map;

//Timeline, table, persons 
Scrub s;
Table table;
ArrayList<Person> persons;

//This will be set based on a home token.
boolean home =false;


void setup() {
  size(800, 600, P2D);

  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(6, 2014);

  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  MapUtils.createDefaultEventDispatcher(this, map);
  getPlace(); //get places based on starting time
}

void draw() {
  background(255);
  map.draw();
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

