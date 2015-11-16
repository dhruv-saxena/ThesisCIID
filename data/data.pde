Table table;
ArrayList<Person> persons;


void setup() {
  size(40, 40);
  persons = new ArrayList<Person>();
  loadData();
  printData();
  
}

void draw() {
  background(255);
}

void loadData() {
  table = loadTable("data.csv", "header");

  for (int i=0; i<table.getRowCount (); i++) {
    TableRow row = table.getRow(i);
    // You can access the fields via their column name (or index)
    String name = row.getString("name");


    if (name.equals("")==false) 
      persons.add(new Person(name)); //Add Person

    //Last Person added
    Person p =  persons.get(persons.size()-1);
    p.places.add(row.getString("place"));
    p.month.append(row.getInt("month"));
    p.year.append(row.getInt("year"));
  }
}

void printData(){
  for (int i=0; i<persons.size (); i++) {
    Person p = persons.get(i);
    println(p.name);
    for (int j=0; j<p.places.size(); j++) {
    //println(p.places.get(j));
      println(p.places.get(j) + "  " + p.month.get(j) + "/" + p.year.get(j));
    }
  }
}

