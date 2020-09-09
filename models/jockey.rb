require_relative 'application_record'

class Jockey < ApplicationRecord
  has_many :results, class_name: 'Entry'

  validates :jockey_id,
            presence: {message: 'absent'}
  validates :jockey_id,
            format: {with: /\A\d+\z/, message: 'invalid'},
            allow_nil: true

  def self.create_or_update!(attribute)
    jockey = find_by(attribute.slice(:jockey_id))
    super(jockey, attribute)
  end

  def self.log_attribute
    super.merge(resource: 'jockey')
  end

  def average_prize_money(time)
    sum_prize_money = results_before(time).map(&:prize_money).inject(:+)
    sum_prize_money ? sum_prize_money / entry_times(time).to_f : 0
  end

  def win_rate(time)
    return 0 if results_before(time).empty?

    results_before(time).count(&:won).to_f / entry_times(time)
  end

  def win_rate_last_four_races(time)
    return 0 if results_before(time).empty?

    last_four_races = results_before(time).first(4)
    last_four_races.count(&:won).to_f / last_four_races.size
  end

  private

  def entry_times(time)
    results_before(time).size
  end

  def results_before(time)
    results.joins(:race)
           .where('races.start_time < ?', time)
           .order('races.start_time desc')
  end
end
