class AddSecondLastRaceOrderToHorsesAndFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :horses, :second_last_race_order, :integer, after: :horse_id
    add_column :features, :second_last_race_order, :integer, after: :round
  end
end
