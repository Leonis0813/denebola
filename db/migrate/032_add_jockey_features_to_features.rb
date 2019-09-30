class AddJockeyFeaturesToFeatures < ActiveRecord::Migration[4.2]
  def change
    change_table :features do |t|
      t.rename :average_prize_money, :horse_average_prize_money
      t.change :horse_average_prize_money, :float, after: :grade
      t.float :jockey_average_prize_money, null: false, after: :horse_average_prize_money
      t.float :jockey_win_rate, null: false, after: :jockey_average_prize_money
      t.float :jockey_win_rate_last_four_races, null: false, after: :jockey_win_rate
    end
  end
end
