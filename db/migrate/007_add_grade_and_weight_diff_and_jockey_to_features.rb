class AddGradeAndWeightDiffAndJockeyToFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :features, :grade, :string, after: :distance
    add_column :features, :weight_diff, :float, after: :weight
    add_column :features, :jockey, :string, after: :grade
  end
end
