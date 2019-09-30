class RemoveJockeyFromEntries < ActiveRecord::Migration[4.2]
  def up
    remove_column :entries, :jockey
    add_reference :entries, :jockey, after: :horse_id
    add_index :entries, %i[jockey_id race_id], unique: true
  end

  def down
    add_column :entries, :jockey, :string, after: :final_600m_time
    remove_column :entries, :jockey_id
    remove_index %i[jockey_id race_id]
  end
end
