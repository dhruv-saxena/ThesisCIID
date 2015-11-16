import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

UnfoldingMap map;

Person p;

void setup() {
  size(800, 600);
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  MapUtils.createDefaultEventDispatcher(this, map);
  p = new Person(width/2, height/2);
}

void draw() {
  background(255);
  map.draw();
//  Location location = map.getLocation(mouseX, mouseY);
  ScreenPosition delhi = map.getScreenPosition(new Location(28.6,77.2));
  fill(255);
  text("hey", 100, 100);
  println(delhi.x,delhi.y);
  //println(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
  p.arrive(new PVector(delhi.x, delhi.y));
  p.update();
  p.display();
}
