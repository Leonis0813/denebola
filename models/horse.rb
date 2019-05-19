class Horse < ActiveRecord::Base
  has_many :results, class_name: 'Entry'

  def average_prize_money
    results.map(&:prize_money).inject(:+) / entry_times.to_f
  end

  def entry_times
    results.size
  end

  def last_race_final_600m_time
    results.second&.final_600m_time
  end

  def last_race_order
    results.second&.order&.to_i
  end

  def rate_within_third
    within_third = results.first(3).select {|result| result.order.to_i <= 3 }.size
    within_third / 3.0
  end

  def second_last_race_order
    results.third&.order&.to_i
  end

  def win_times
    results.select {|result| result.order.to_i == 1 }.size
  end
end
