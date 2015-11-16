import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

UnfoldingMap map;

void setup() {
  size(800, 600);
  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  MapUtils.createDefaultEventDispatcher(this, map);
}

void draw() {
    map.draw();
    Location location = map.getLocation(mouseX, mouseY);
    fill(255,0,0);
    text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
}