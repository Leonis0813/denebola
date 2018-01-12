CREATE TABLE IF NOT EXISTS features (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  track VARCHAR(6) NOT NULL,
  direction VARCHAR(2) NOT NULL,
  distance INTEGER NOT NULL,
  weather VARCHAR(6) NOT NULL,
  place VARCHAR(16) NOT NULL,
  round INTEGER NOT NULL,
  number INTEGER NOT NULL,
  age INTEGER NOT NULL,
  burden_weight FLOAT NOT NULL,
  weight FLOAT,
  `order` VARCHAR(2) NOT NULL,
  race_id INTEGER,
  entry_id INTEGER,
  UNIQUE(race_id, entry_id)
)
