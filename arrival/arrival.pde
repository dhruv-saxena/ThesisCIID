Person p;

void setup(){
  size(800,400);
  p = new Person(width/2,height/2);
  fill(100);
  noStroke();
}


void draw(){
  background(255);
  p.arrive(new PVector(mouseX,mouseY));
  p.update();
  p.display();
  //println(p.location);
  //p.printPoints();
  
}