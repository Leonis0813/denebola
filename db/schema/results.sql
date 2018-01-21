CREATE TABLE IF NOT EXISTS results (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  `order` VARCHAR(2) NOT NULL,
  race_id INTEGER,
  entry_id INTEGER,
  UNIQUE(race_id, entry_id)
)
