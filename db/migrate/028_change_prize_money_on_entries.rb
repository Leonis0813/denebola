# coding: utf-8

class ChangePrizeMoneyOnEntries < ActiveRecord::Migration[4.2]
  def change
    change_column_null :entries, :prize_money, false, 0
  end
end
