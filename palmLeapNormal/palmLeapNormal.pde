import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Hand;

float pitch;
PVector position;
PVector normal;
PVector velocity;
float count = 0;
LeapMotionP5 leap;

public void setup() {
  size(500, 900);
  leap = new LeapMotionP5(this);
  position = new PVector(0, 0, 0);
  normal = new PVector(0, 0, 0);
  velocity = new PVector(0, 0, 0);
}

void draw() {
  background(255);
  fill(100);
  if (leap.getHandList().size()>0) {
    normal = leap.getNormal(leap.getHandList().get(0));
    position = leap.getPosition(leap.getHandList().get(0));
    velocity = leap.getVelocity(leap.getHandList().get(0));
    
      
  if(normal.y>1.5 && velocity.y>100)
  count+=velocity.y/3000;
  else if(normal.y<-1.5 && velocity.y<-100)
  count+=velocity.y/3000;
  println(int(count));
  }
//  println("normal  " + normal.y);
//  println("position  " + position.y);
//  println("velocity  " + velocity.y);

}


//pos.x = width/2;
//pos.y = constrain(pos.y, height/2-height/8, height/2+height/8);
//pos.y = map(pos.y, height/2-height/8, height/2+height/8, height/4, height/2+height/4);  
//ellipse(pos.x, pos.y, 10, 10);
//println(pos);

