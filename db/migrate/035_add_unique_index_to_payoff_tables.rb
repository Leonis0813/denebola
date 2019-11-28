class AddUniqueIndexToPayoffTables < ActiveRecord::Migration[4.2]
  def change
    add_index :wins, %i[race_id], unique: true
    add_index :bracket_quinellas, %i[race_id], unique: true
    add_index :quinellas, %i[race_id], unique: true
    add_index :exactas, %i[race_id], unique: true
    add_index :trios, %i[race_id], unique: true
    add_index :trifectas, %i[race_id], unique: true
    add_index :shows, %i[odds favorite number race_id], unique: true
    add_index :quinella_places, %i[odds favorite number1 number2 race_id],
              unique: true,
              name: 'index_unique_quinella_places'
  end
end
