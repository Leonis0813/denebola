class ChangeFeatures < ActiveRecord::Migration[4.2]
  def change
    change_table :features, bulk: true do |t|
      t.float :average_prize_money, after: :age
      t.integer :blank, after: :average_prize_money
      t.float :distance_diff, after: :distance
      t.integer :entry_times, after: :distance_diff
      t.float :rate_within_third, after: :place
      t.string :running_style, after: :round
      t.integer :win_times, after: :weight_per
    end
  end
end
