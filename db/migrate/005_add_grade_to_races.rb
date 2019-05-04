class AddGradeToRaces < ActiveRecord::Migration[4.2]
  def change
    add_column :races, :grade, :string, after: :round
  end
end
