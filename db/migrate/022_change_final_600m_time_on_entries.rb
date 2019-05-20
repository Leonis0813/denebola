class ChangeFinal600mTimeOnEntries < ActiveRecord::Migration[4.2]
  def change
    change_column :entries, :final_600m_time, :float
  end
end
