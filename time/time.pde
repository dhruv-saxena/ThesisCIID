Scrub s;


void setup() {
  size(400, 400);

  s = new Scrub(1,2008);
}

void draw() {
  background(255);
  println(s.month + "/" +s.year);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      s.increase();
    } else if (keyCode == DOWN) {
      s.decrease();
    }
  }
}

