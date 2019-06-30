class AddRunningStyleToHorses < ActiveRecord::Migration[4.2]
  def change
    add_column :horses, :running_style, :string, after: :horse_id
  end
end
