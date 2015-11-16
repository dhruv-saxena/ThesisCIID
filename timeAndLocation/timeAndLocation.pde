Scrub s;
Table table;
ArrayList<Person> persons;


void setup() {
  size(400, 400);
  persons = new ArrayList<Person>();
  loadData();
  s = new Scrub(1, 2008);
}

void draw() {
  background(255);
}

void keyPressed() {

  println(s.month + "/" +s.year);
  getPlace();

  if (key == CODED) {
    if (keyCode == UP) {
      s.increase();
    } else if (keyCode == DOWN) {
      s.decrease();
    }
  }
}

void loadData() {
  table = loadTable("data.csv", "header");

  for (int i=0; i<table.getRowCount (); i++) {
    TableRow row = table.getRow(i);
    // You can access the fields via their column name (or index)
    String name = row.getString("name");


    if (name.equals("")==false) //Only when name is non empty
      persons.add(new Person(name)); //Add Person

    Person p =  persons.get(persons.size()-1); //Get last person in list i.e the one just added
    p.places.add(row.getString("place")); //Add place, month and year to this person
    p.month.append(row.getInt("month")); //The addition keeps happening for the whole for loop
    p.year.append(row.getInt("year")); //So unless a new person is detected, keep adding place, month and year to the last person
    
    //Also adding co-ordinates
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    p.cordinates.add(new PVector(x,y));
}
}

void printData() {
  for (int i=0; i<persons.size (); i++) {
    Person p = persons.get(i);
    println(p.name);
    for (int j=0; j<p.places.size (); j++) {
      println(p.places.get(j) + "  " + p.month.get(j) + "/" + p.year.get(j));
    }
  }
}

void getPlace() {
  //Get place according to time for each person
  
  //iterate over each person
  for (int i=0; i<persons.size (); i++) {
    Person p = persons.get(i);
    println(p.name);
  
  //get the right place index according to time
    int index = -1;
    for (int k=0; k<p.year.size (); k++) {
      if (s.year > p.year.get(k)) {
        index = k;
      } else if (s.year == p.year.get(k)) {
        if (s.month >= p.month.get(k))
          index = k;
      }
    }
    if (index>-1){    
      p.targetMap = p.cordinates.get(index); 
     println(p.places.get(index) + " X: " + p.targetMap.x + " Y: " + p.targetMap.y); //here you can do what you need with the place       
  }
  }
}

