# coding: utf-8

class ChangeDirectionOnRaces < ActiveRecord::Migration[4.2]
  def change
    change_column_null :races, :direction, false, '障'
  end
end
