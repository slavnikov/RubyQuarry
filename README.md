# RubyQuarry
A simple object-relational mapping library for managing SQLite3 databases with syntactic Ruby methods. Reduces the need for writing of raw SQL code and provides tools for creating relationships between objects allowing efficient retrieval of linked resources.

## Configuration
Clone the repository and place the lib folder into your working root folder.
```bash
  git clone https://github.com/slavnikov/RubyQuarry.git
```
In the db_connection.rb file, insert the name of your database file. You can also the name of a setup sql file that creates the tables in the database, which will allow you to reset your database with an included method. Place both files in your project's root directory.

```Ruby
# db_connection.rb

DB_SQL_FILE = File.join(ROOT_FOLDER, 'example.sql')
DB_FILE = File.join(ROOT_FOLDER, 'example.db')
```

## Use

When creating a model for a new database resource, require associatable_through.rb in the files that will be creating database model classes. Create classes representing the different resources in your database and have them inherit from the SQLObject class. At the end of each class declaration, run self.finalize! to create the necessary attribute associations.

```Ruby
require '/lib/associatable_through'

class Movie < SQLObject
  self.finalize!
end

class Director < SQLObject
  self.finalize!
end
```


In order for the library to associate your model classes and database tables automatically, make sure that the names of the tables are the lowercase, pluralized versions of the model class names.

```SQL
-- if the model class is named Resource as above, the sql table setup would be as follows
CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  director_id INTEGER,

  FOREIGN KEY(director_id) REFERENCES director(id)
);

CREATE TABLE directors (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);
  ```

## Demo

To interact with the demo:
1. navigate to the db_connection.rb file
   + comment out lines 6 & 7
   + comment in lines 8 & 9
2. Use your preferred REPL to load in DEMO.rb
3. With the 3 models provided (Movie, Director, Studio), try out the different methods listed below.

## Main Methods

#### ::new(attributes)

Creates a new instance of the object class with the attributes passed in as a key-values hash.

```Ruby
  copolla = Director.new({name: "Francis F. Copolla"})
  movie = Movie.new({title: "The Godfather", director_id: 1})
  movie2 = Movie.new({title: "The Godfather: Part 2", director_id: 1})
```

#### ::all

Returns an array of all the resources in a database table associated with a given model.

```Ruby
  Movie.all #=> [#<Movie:0x000055a3163c5870 @attributes={:id=>1, :title=>"The Godfather", :director_id=>1}>, #<Movie:0x0000 .... ]
```

#### ::first

Returns the first resource in the database associated with a given model.

#### ::last

Returns the last resource in the database associated with a given model.

#### ::find(id)

Returns a single object representing a record in the database with a matching id.

```Ruby
Movie.find(2) #=> #<Movie:0x00005620b0aa0178 @attributes={:id=>2, :title=>"The Godfather: Part 2", :director_id=>1}>
```

#### ::find_by(param)

Returns an object representing the first record in the database that matches the parameter passed as the argument.

```Ruby
Movie.find_by(name: "The Godfather") #=> #<Movie:0x000055a3163c5870 @attributes={:id=>1, :title=>"The Godfather", :director_id=>1}>
```

#### ::where(params)

Returns an array of object that match the parameters passed in as a key value hash in the arguments. Functions similarly to #find_by but accepts multiple keys and values and return an array even if only one matching record is brought back.

#### #save

Saves the object instance as a record in the database or an already existing record with the same id. Returns the id upon a successful save.

```Ruby
  movie = Movie.new({title: "The Godfather", director_id: 1})
  # No id is found because the record is not in the database.
  movie.id #=> nil
  movie.save #=> 1
  # Saving adds an id after putting the record into the database.
  movie.id #=> 1
  # The instance can be modified but the change will not be reflected in the database until it is saved.
  movie.name = "Goodfellas"
  Movie.find(1) #=> #<Movie:0x000055a3163c5870 @attributes={:id=>1, :title=>"The Godfather", :director_id=>1}>
  movie.save
  Movie.find(1) #=> #<Movie:0x000055a3163c5870 @attributes={:id=>1, :title=>"Goodfellas", :director_id=>1}>
```

#### #[attribute_name]

Returns the attribute of a given record.

```Ruby
  godfather.director_id #=> 1
  copolla.name #=> "Francis F. Copolla"
```

#### #[attr_name]=(value)

Sets the given attribute to the value passed as the argument.

## Association Methods

#### ::belongs_to(name, options = {})

Associates the class to another class via a foreign key. By default the foreign key is set to :name_id, primary key is set to :id, and name of associated key is set to :Name. These defaults can be overriden with an options hash that lists keys of :foreign_key, :primary_key, and :class_name, and sets values for the same.

```Ruby
#Sets the default options of {foreign_key: :director_id, primary_key: :id, class_name: :Director}
Movie.belongs_to(:director)
```

#### ::has_many(name, options = {})

Associates the class to another class via a foreign key. By default the foreign key is set to :own_class_id, primary key is set to :id, and name of associated key is set to :Name. These defaults can be overriden with an options hash that lists keys of :foreign_key, :primary_key, and :class_name, and sets values for the same.

```Ruby
#Sets the default options of {foreign_key: :director_id, primary_key: :id, class_name: :Movie}
Director.has_many(:movies)
```
#### #[association]

Returns an object representing the linked associated record(s).

```Ruby
  movie.director #=> #<Director:0x0000559953a76308 @attributes={:id=>1, :name=>"Francis F. Copolla"}>
  director.movies #=> [#<Movie:0x0000559953e3e238 @attributes={:id=>1, :title=>"The Godfather", :director_id=>1}>, #<Movie:0x0000559953e3e030 @attributes={:id=>2, :title=>"The Godfather: Part 2", :director_id=>1}>]
```
