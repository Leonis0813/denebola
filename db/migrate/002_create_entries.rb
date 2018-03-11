class CreateEntries < ActiveRecord::Migration
  def self.change
    create_table :entries do |t|
      t.integer :number, :null => false
      t.integer :age, :null => false
      t.float :burden_weight, :null => false
      t.float :weight
      t.references :race

      t.timestamps :null => false
    end

    add_index :entries, [:race_id, :number], :unique => true
  end
end
