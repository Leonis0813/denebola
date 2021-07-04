class AddIndexRaceIdAndNumberToFeatures < ActiveRecord::Migration[4.2]
  def change
    add_index :features, %i[race_id number], unique: true
  end
end
