CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  director_id INTEGER,

  FOREIGN KEY(director_id) REFERENCES director(id)
);

CREATE TABLE directors (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  studio_id INTEGER,

  FOREIGN KEY(studio_id) REFERENCES director(id)
);

CREATE TABLE studios (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  studios (id, name)
VALUES
  (1, "Dreamworks"), (2, "Warner Bros."), (3, "Lucas Films");

INSERT INTO
  directors (id, fname, lname, studio_id)
VALUES
  (1, "George", "Lucas", 3),
  (2, "Steven", "Spielberg", 1),
  (3, "Wachowski", "Brothers", 2),
  (4, "Chris", "Columbus", 2);

INSERT INTO
  movies (id, title, director_id)
VALUES
  (1, "Catch Me If You Can", 2),
  (2, "Saving Private Ryan", 2),
  (3, "Star Wars Episode IV", 1),
  (4, "Star Wars Epsiode V", 1),
  (5, "The Matrix", 3),
  (6, "Harry Potter and the Sorcerer's Stone", 4);
