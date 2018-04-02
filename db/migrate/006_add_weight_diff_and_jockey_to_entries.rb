class AddWeightDiffAndJockeyToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :weight_diff, :float, :after => :weight
    add_column :entries, :jockey, :string, :after => :weight_diff
  end
end
