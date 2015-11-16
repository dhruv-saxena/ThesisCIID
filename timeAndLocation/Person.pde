class Person {

  String name;
  ArrayList<String> places;
  ArrayList<PVector> cordinates;
  IntList month;
  IntList year;
  PVector targetMap;
  

  Person(String n) {
    name = n;
    places = new ArrayList<String>();
    cordinates = new ArrayList<PVector>();
    month = new IntList();
    year = new IntList();
    targetMap = new PVector(width/2,height/2);  
  }
}

