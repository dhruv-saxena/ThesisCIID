//Load data from DB into persons arraylist. This function should remain same in next versions.
//The function solely pertains to DB, and nothing else.
//The function is called in the setup, and would be called in the setup of all sketches further on.
void loadData() {
  table = loadTable("data.csv", "header");

  for (int i=0; i<table.getRowCount (); i++) {
    TableRow row = table.getRow(i);
    // You can access the fields via their column name (or index)
    String name = row.getString("name");
    float homeX = row.getFloat("homeX");
    float homeY = row.getFloat("homeY");


    if (name.equals("")==false) //Only when name is non empty i.e when a name is present
      persons.add(new Person(name,homeX,homeY)); //Add Person with name and home city cordinates

    Person p =  persons.get(persons.size()-1); //Get last person in list i.e the one just added
    p.places.add(row.getString("place")); //Add place, month and year to this person
    p.month.append(row.getInt("month")); //The addition keeps happening for the whole for loop
    p.year.append(row.getInt("year")); //So unless a new person is detected, keep adding place, month and year to the last person

    //Also adding co-ordinates
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    p.cordinates.add(new PVector(x, y));
  }
}

//Get place according to time for each person. This function should remain same in next versions.
//The function attends to time and based on it sets the targetMap variable for each person.
//The function is only called when there is a change in time. In this case detected by a keypress.
void getPlace() {

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
    if (index>-1) {    
      p.targetMap = p.cordinates.get(index); 
      println(p.places.get(index) + " X: " + p.targetMap.x + " Y: " + p.targetMap.y); //here you can do what you need with the place
    }
    else
      p.targetMap = p.home;
  }
}

//This function is responsible for the movement of persons.
// The only thing that you might need to replace is you create your own map is the "ScreenPosition" line.
// You will have to put in your algorithm to get the pixel positions for the lat and long values in targetMap.
//Remember that targetMap is there in every person, and it holds only the relevant lat and long according to scrub.
void movePersons() {
  for (Person p : persons) {
    PVector pos;
    
    if(home)
    pos = mercatorMap.getScreenLocation(p.home);
    
    else
    //get the screen position for the relevant lat and long
    pos = mercatorMap.getScreenLocation(p.targetMap);
    
    p.arrive(pos);
    p.update();
    p.display();
  }
}
