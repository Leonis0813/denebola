class ChangeRunningStyleOnHorses < ActiveRecord::Migration[4.2]
  def change
    change_column :horses, :running_style, :string, null: false
  end
end
