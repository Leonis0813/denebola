class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.string :order, :null => false
      t.references :race
      t.references :entry

      t.timestamps :null => false
    end

    add_index :results, [:race_id, :entry_id], :unique => true
  end

  def self.down
    drop_table :results
  end
end
