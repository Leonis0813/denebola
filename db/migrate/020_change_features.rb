class ChangeFeatures < ActiveRecord::Migration[4.2]
  def change
    change_table :features, bulk: true do |t|
      t.float :average_prize_money, null: false, after: :age
      t.integer :blank, after: :average_prize_money
      t.float :distance_diff, null: false, after: :distance
      t.integer :entry_times, null: false, after: :distance_diff
      t.float :rate_within_third, after: :place
      t.string :running_style, null: false, after: :round
      t.integer :win_times, null: false, after: :weight_per
      t.remove_index %i[race_id entry_id]
      t.remove :entry_id
      t.remove :race_id
      t.string :horse_id, null: false, after: :grade
      t.string :race_id, null: false, after: :place
    end
  end
end
