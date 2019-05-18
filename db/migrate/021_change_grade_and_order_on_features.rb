class ChangeGradeAndOrderOnFeatures < ActiveRecord::Migration[4.2]
  def change
    change_column_null :features, :grade, false, 0
    change_table :features, bulk: true do |t|
      t.change :grade, :string, default: 'N'
      t.remove :order
      t.boolean :won, null: false, default: false, after: :win_times
    end
  end
end
