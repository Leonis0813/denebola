class AddWeightDiffToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :weight_diff, :float, :after => :weight
  end
end
