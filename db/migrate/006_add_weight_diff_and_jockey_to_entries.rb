class AddWeightDiffAndJockeyToEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :entries, :weight_diff, :float, after: :weight
    add_column :entries, :jockey, :string, after: :burden_weight
  end
end
