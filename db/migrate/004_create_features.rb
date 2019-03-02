class CreateFeatures < ActiveRecord::Migration[4.2]
  def change
    create_table :features do |t|
      t.string :track, :null => false
      t.string :direction, :null => false
      t.integer :distance, :null => false
      t.string :weather, :null => false
      t.string :place, :null => false
      t.integer :round, :null => false
      t.integer :number, :null => false
      t.integer :age, :null => false
      t.float :burden_weight, :null => false
      t.float :weight
      t.string :order, :null => false
      t.references :race
      t.references :entry

      t.timestamps :null => false
    end

    add_index :features, [:race_id, :entry_id], :unique => true
  end
end
