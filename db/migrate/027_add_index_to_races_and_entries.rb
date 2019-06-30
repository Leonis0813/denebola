class AddIndexToRacesAndEntries < ActiveRecord::Migration[4.2]
  def change
    add_index :races, %i[race_id], unique: true
    add_index :entries, %i[horse_id race_id], unique: true
  end
end
