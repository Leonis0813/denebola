class Horse < ActiveRecord::Base
  has_many :results, class_name: 'Entry'

  def average_prize_money(time)
    results_before(time).map(&:prize_money).inject(:+) / entry_times(time).to_f
  end

  def entry_times(time)
    results_before(time).size
  end

  def last_race_final_600m_time(time)
    results_before(time).second&.final_600m_time
  end

  def last_race_order(time)
    results_before(time).second&.order&.to_i
  end

  def rate_within_third(time)
    within_third = results_before(time).first(3).select do |result|
      result.order.to_i <= 3
    end.size
    within_third / 3.0
  end

  def second_last_race_order(time)
    results_before(time).third&.order&.to_i
  end

  def win_times(time)
    results_before(time).select(&:won).size
  end

  def results_before(time)
    results.select {|result| result.race.start_time <= time }
  end
end
