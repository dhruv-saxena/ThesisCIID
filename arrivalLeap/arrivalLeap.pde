import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;

LeapMotionP5 leap;
Person p;
PVector leapPos;

void setup() {
  size(800, 400);
  leap = new LeapMotionP5(this);
  p = new Person(width/2, height/2);
  leapPos = new PVector(0, 0);
  fill(100);
  noStroke();
}


void draw() {
  background(255);
  fill(0,150,130,150);
  ellipse(width/2, height/4,50,50);
  ellipse(width/2,height/2+height/4,50,50);
  leapAvg();
  p.arrive(leapPos);
  p.update();
  p.display();
  
  //println(p.location);
  //p.printPoints();
}

void leapAvg() {

  PVector location = new PVector(0, 0);
  if (leap.getFingerList().size()==5) {
    for (Finger finger : leap.getFingerList ()) {
      PVector fingerPos = leap.getTip(finger);
      location.add(fingerPos);
      //ellipse(fingerPos.x, fingerPos.y, 10, 10);
    }
    location.div(leap.getFingerList().size());
    println(leap.getFingerList().size());
    //location.x=width/2;
  } else if (leap.getFingerList().size()==0) {
    println("STOP");
    location.set(width/2,height/2);
    leapPos.set(location);
  }
  
  if(location.y>height/4 && location.y<(height/2+height/4))
  leapPos.set(location);
}

