class Scrub {

  int month;
  int year;

  Scrub() {
    month = month();
    year = year();
  }

    Scrub(int m, int y) {
    month = m;
    year = y;
  }

  void increase() {
    if (month>=12) {
      month=1;
      year+=1;
    } else
      month+=1;
  }

  void decrease() {
    if (month<=1) {
      month=12;
      year-=1;
    } else
      month-=1;
  }
}

