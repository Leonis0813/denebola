class AddMonthAndSexAndWeightPerToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :month, :string, :null => false, :after => :grade
    add_column :features, :sex, :string, :null => false, :after => :age
    add_column :features, :weight_per, :float, :after => :weight_diff
  end
end
