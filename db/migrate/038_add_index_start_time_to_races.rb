class AddIndexStartTimeToRaces < ActiveRecord::Migration[4.2]
  def change
    add_index :races, :start_time
  end
end
