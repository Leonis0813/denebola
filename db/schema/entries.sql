CREATE TABLE IF NOT EXISTS entries (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  number INTEGER NOT NULL,
  age INTEGER NOT NULL,
  burden_weight FLOAT NOT NULL,
  weight FLOAT,
  race_id INTEGER,
  UNIQUE(race_id, number)
)
