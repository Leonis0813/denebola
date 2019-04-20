class AddLastRaceOrderToHorsesAndFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :horses, :last_race_order, :integer, :after => :horse_id
    add_column :features, :last_race_order, :integer, :after => :jockey
  end
end
