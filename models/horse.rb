# coding: utf-8
class Horse < ActiveRecord::Base
  has_many :results, class_name: 'Entry'

  validates :horse_id, presence: {message: 'absent'}
  validates :horse_id, format: {with: /\A\d+\z/, message: 'invalid'}
  validates :running_style,
            inclusion: {
              in: %w[逃げ 先行 差し 追込],
              message: 'invalid',
            },
            allow_nil: true

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
      %w[1 2 3].include?(result.order)
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
    target_results = results.select {|result| result.race.start_time <= time }
    target_results.sort_by {|result| result.race.start_time }.reverse
  end
end
