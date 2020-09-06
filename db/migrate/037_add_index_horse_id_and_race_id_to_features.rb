class AddIndexHorseIdAndRaceIdToFeatures < ActiveRecord::Migration[4.2]
  def change
    add_index :features, %i[horse_id race_id], unique: true
  end
end
