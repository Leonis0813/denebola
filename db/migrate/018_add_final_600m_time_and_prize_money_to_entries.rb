class AddFinal600mTimeAndPrizeMoneyToEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :entries, :final_600m_time, :double, after: :burden_weight
    add_column :entries, :prize_money, :integer, after: :order
  end
end
