PImage land;
PImage water;


//Timeline, table, persons 

Table table;
ArrayList<Person> persons;

void setup() {

  size(720, 450, P2D);// Use fullScreen mode, FX2D can create strange offsets when size is defined.
  //fullScreen(FX2D);

  frameRate(60);
  noStroke();  


  persons = new ArrayList<Person>();
  loadData();

  for (Person p : persons) {
    println(p.name + "  " + p.homeCity + "-" + p.home.x + "/"+ p.home.y);
    for (int i=0; i<p.month.size(); i++) {
      println(p.roles.get(i) + "  " + p.organisations.get(i) + "  " + p.places.get(i)+ " - " + p.cordinates.get(i).x + "/" + p.cordinates.get(i).y +"  " + p.month.get(i) + "/" + p.year.get(i) );
    }
  }
}

void draw() {
}


void loadData() {
  table = loadTable("kinSpace.csv", "header");

  for (int i=0; i<table.getRowCount (); i++) {
    TableRow row = table.getRow(i);
    // You can access the fields via their column name (or index)
    String nameCheck = trim(row.getString("Name")); //Trim whiteSpaces because you cannot see them in the spreadsheet.
    if (nameCheck.length()>0) { //if a name exists in the row, then get this information, make a new person and add the informtion to it.
      String name = row.getString("Name");
      String homeInfo = row.getString("Home");
      String background = row.getString("Background");

      String homeCity = "";
      float homeCityX = 0;
      float homeCityY = 0;
      String[] home = splitTokens(homeInfo, "-,/");
      if (home.length>0) {
        homeCity = home[0];
        homeCityX = float(home[home.length-2]);
        homeCityY = float(home[home.length-1]);
      }
      persons.add(new Person(name, homeCity, homeCityX, homeCityY, background)); //Add Person with name and home city cordinates
    }


    String roleCheck = trim(row.getString("Role/Designation/Degree"));
    if (roleCheck.length()>0) { //making sure there is something in the row and we have not encountered an empty row
      String role = row.getString("Role/Designation/Degree");
      String org = row.getString("Organisation");

      int month = row.getInt("Starting Month");
      int year = row.getInt("Starting Year");

      String cityInfo = row.getString("Location (City)");
      String[] city = splitTokens(cityInfo, "-,/");

      String workCity = "";
      float workCityX = 0;
      float workCityY = 0;

      if (city.length>0) {
        workCity = city[0];
        workCityX = float(city[city.length-2]);
        workCityY = float(city[city.length-1]);
      }

      Person p =  persons.get(persons.size()-1); //Get last person in list i.e the one just added
      p.month.append(month);
      p.year.append(year);
      p.roles.add(role);
      p.organisations.add(org);
      p.places.add(workCity);
      p.cordinates.add(new PVector(workCityX, workCityY));
    }
  }
}