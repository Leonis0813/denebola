class ChangeDirectionOnRaces < ActiveRecord::Migration[4.2]
  def change
    change_column :races, :direction, :string, null: false
  end
end
