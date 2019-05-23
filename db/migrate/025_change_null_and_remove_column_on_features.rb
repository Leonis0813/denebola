# coding: utf-8

class ChangeNullAndRemoveColumnOnFeatures < ActiveRecord::Migration[4.2]
  def up
    change_column_null :features, :blank, false, 0
    change_column_null :features, :direction, false, '障'
    change_column_null :features, :last_race_order, false, 0
    change_column_null :features, :rate_within_third, false, 0
    change_column_null :features, :second_last_race_order, false, 0
    change_column_null :features, :weight, false, 0.0
    change_column_null :features, :weight_diff, false, 0.0
    change_column_null :features, :weight_per, false, 0.0

    change_table :features, bulk: true do |t|
      t.remove :jockey
      t.remove :last_race_final_600m_time
    end
  end
end
