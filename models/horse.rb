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

  def self.create_or_update!(attribute)
    horse = find_by(attribute.slice(:horse_id))
    super(horse, attribute)
  end

  def self.log_attribute
    super.merge(resource: 'horse')
  end

  def extra_attribute(time)
    results_before = results.joins(:race)
                            .where('races.start_time < ?', time)
                            .order('races.start_time desc')

    blank = if results_before.second
              (time.to_date - results_before.first.race.start_time.to_date).to_i
            else
              0
            end

    {
      blank: blank,
      entry_times: results_before.size,
      horse_average_prize_money: average_prize_money(results_before),
      last_race_order: last_race_order(results_before),
      rate_within_third: rate_within_third(results_before),
      second_last_race_order: second_last_race_order(results_before),
      win_times: results_before.count(&:won),
    }
  end

  def average_prize_money(results)
    results.average(:prize_money) || 0
  end

  def last_race_order(results)
    results.first&.order&.to_i || 0
  end

  def rate_within_third(results)
    return 0 if results.empty?

    within_third = results.first(3).count do |result|
      %w[1 2 3].include?(result.order)
    end
    within_third / [3.0, results.size.to_f].min
  end

  def second_last_race_order(results)
    results.second&.order&.to_i || 0
  end
end
