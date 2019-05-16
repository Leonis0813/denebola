class AddMonthAndSexAndWeightPerToFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :features, :month, :integer, null: false, after: :jockey
    add_column :features, :sex, :string, null: false, after: :round
    add_column :features, :weight_per, :float, after: :weight_diff
  end
end
