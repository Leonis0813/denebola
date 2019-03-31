class AddGradeAndWeightDiffAndJockeyToFeatures < ActiveRecord::Migration[4.2]
  def change
    add_column :features, :grade, :string, :after => :round
    add_column :features, :weight_diff, :float, :after => :weight
    add_column :features, :jockey, :string, :after => :weight_diff
  end
end
