class ChangeIndexOnEntries < ActiveRecord::Migration[4.2]
  def change
    change_table :entries, bulk: true do |t|
      t.remove_index %i[jockey_id race_id]
      t.index %i[race_id jockey_id number], unique: true
    end
  end
end
