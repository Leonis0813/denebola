# coding: utf-8

require_relative 'application_record'

class Horse < ApplicationRecord
  RUNNING_STYLE_LIST = %w[逃げ 先行 差し 追込].freeze

  has_many :results, class_name: 'Entry'

  validates :horse_id, :running_style,
            presence: {message: 'absent'}
  validates :horse_id,
            format: {with: /\A\d+\z/, message: 'invalid'},
            allow_nil: true
  validates :running_style,
            inclusion: {in: RUNNING_STYLE_LIST, message: 'invalid'},
            allow_nil: true

  scope :results_before, lambda {|time|
    results.joins(:race)
           .where('races.start_time < ?', time)
           .order('races.start_time desc')
  }

  def self.create_or_update!(attribute)
    horse = find_by(attribute.slice(:horse_id))
    super(horse, attribute)
  end

  def self.log_attribute
    super.merge(resource: 'horse')
  end

  def average_prize_money(time)
    sum_prize_money = results_before(time).map(&:prize_money).inject(:+)
    sum_prize_money ? sum_prize_money / entry_times(time).to_f : 0
  end

  def entry_times(time)
    results_before(time).size
  end

  def last_race_order(time)
    results_before(time).first&.order&.to_i || 0
  end

  def rate_within_third(time)
    return 0 if results_before(time).empty?

    within_third = results_before(time).first(3).count do |result|
      %w[1 2 3].include?(result.order)
    end
    within_third / [3.0, results_before(time).size.to_f].min
  end

  def second_last_race_order(time)
    results_before(time).second&.order&.to_i || 0
  end

  def win_times(time)
    results_before(time).count(&:won)
  end
end
