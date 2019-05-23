# coding: utf-8

class Horse < ActiveRecord::Base
  RUNNING_STYLE_LIST = %w[逃げ 先行 差し 追込].freeze

  has_many :results, class_name: 'Entry'

  validates :horse_id, :running_style,
            presence: {message: 'absent'}
  validates :horse_id,
            format: {with: /\A\d+\z/, message: 'invalid'}
  validates :running_style,
            inclusion: {in: RUNNING_STYLE_LIST, message: 'invalid'}

  def average_prize_money(time)
    results_before(time).map(&:prize_money).inject(:+) / entry_times(time).to_f
  end

  def entry_times(time)
    results_before(time).size
  end

  def last_race_order(time)
    results_before(time).second&.order&.to_i || 0
  end

  def rate_within_third(time)
    within_third = results_before(time).first(3).select do |result|
      %w[1 2 3].include?(result.order)
    end.size
    within_third / 3.0
  end

  def second_last_race_order(time)
    results_before(time).third&.order&.to_i || 0
  end

  def win_times(time)
    results_before(time).select(&:won).size
  end

  def results_before(time)
    @results_before ||= results.joins(:race).where('races.start_time <= ?', time)
                               .order('races.start_time desc')
  end
end
