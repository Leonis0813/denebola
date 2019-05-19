# coding: utf-8

class ChangeDirectionOnRacesAndFeatures < ActiveRecord::Migration[4.2]
  def up
    change_column_null :races, :direction, true
    change_column_null :features, :direction, true
  end

  def down
    change_column_null :races, :direction, false, '芝'
    change_column :races, :direction, :string, null: false
    change_column_null :features, :direction, false, '芝'
    change_column :features, :direction, :string, null: false
  end
end
