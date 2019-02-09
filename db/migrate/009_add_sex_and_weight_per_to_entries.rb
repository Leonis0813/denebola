class AddSexAndWeightPerToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :sex, :string, :null => false, :after => :age
    add_column :entries, :weight_per, :float, :after => :weight_diff
  end
end
