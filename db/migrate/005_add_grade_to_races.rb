class AddGradeToRaces < ActiveRecord::Migration
  def change
    add_column :races, :grade, :string, :after => :round
  end
end
