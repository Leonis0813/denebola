CREATE TABLE IF NOT EXISTS features (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  track VARCHAR(6),
  direction VARCHAR(2),
  distance INTEGER,
  weather VARCHAR(6),
  place VARCHAR(16),
  round INTEGER,
  number INTEGER,
  age INTEGER,
  burden_weight FLOAT,
  weight FLOAT,
  `order` VARCHAR(2),
  race_id INTEGER NOT NULL,
  entry_id INTEGER NOT NULL,
  UNIQUE(race_id, entry_id)
)
