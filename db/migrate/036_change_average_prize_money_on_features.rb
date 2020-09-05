# coding: utf-8

class ChangeAveragePrizeMoneyOnFeatures < ActiveRecord::Migration[4.2]
  def up
    change_column :features, :horse_average_prize_money, :decimal,
                  precision: 12,
                  scale: 3,
                  null: false
    change_column :features, :jockey_average_prize_money, :decimal,
                  precision: 12,
                  scale: 3,
                  null: false
  end

  def down
    change_column :features, :horse_average_prize_money, :float, null: false
    change_column :features, :jockey_average_prize_money, :float, null: false
  end
end
