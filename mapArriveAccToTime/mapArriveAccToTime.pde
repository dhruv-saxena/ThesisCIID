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


void setup() {
  size(800, 600, P2D);

  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(4, 2010);

  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  MapUtils.createDefaultEventDispatcher(this, map);
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
  }
}


