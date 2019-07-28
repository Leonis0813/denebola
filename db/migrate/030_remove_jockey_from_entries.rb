class RemoveJockeyFromEntries < ActiveRecord::Migration[4.2]
  def up
    remove_column :entries, :jockey
  end

  def down
    add_column :entries, :jockey, :string, after: :final_600m_time
  end
end
