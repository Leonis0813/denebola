class ChangeDirectionOnRaces < ActiveRecord::Migration[4.2]
  def up
    change_column :races, :direction, :string, null: true
  end

  def down
    change_column :races, :direction, :string, null: false
  end
end
