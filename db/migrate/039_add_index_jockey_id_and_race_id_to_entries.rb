class AddIndexJockeyIdAndRaceIdToEntries < ActiveRecord::Migration[4.2]
  def change
    add_index :entries, %i[jockey_id race_id], unique: true
  end
end
