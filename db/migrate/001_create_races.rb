class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.string :track, :null => false
      t.string :direction, :null => false
      t.integer :distance, :null => false
      t.string :weather, :null => false
      t.string :place, :null => false
      t.integer :round, :null => false
      t.datetime :start_time, :null => false

      t.timestamps :null => false
    end

    add_index :races, [:place, :start_time], :unique => true
  end

  def self.down
    drop_table :races
  end
end
