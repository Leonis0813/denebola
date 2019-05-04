class AddSecondLastRaceOrderToHorsesAndFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :horses, :second_last_race_order, :integer, after: :last_race_order
    add_column :features, :second_last_race_order, :integer, after: :last_race_order
  end
end
