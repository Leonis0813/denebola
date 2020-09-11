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

  def extra_attribute(time)
    results_before = results.joins(:race)
                            .where('races.start_time < ?', time)
                            .order('races.start_time desc')

    {
      jockey_average_prize_money: average_prize_money(results_before),
      jockey_win_rate: win_rate(results_before),
      jockey_win_rate_last_four_races: win_rate_last_four_races(results_before),
    }
  end

  def average_prize_money(results)
    sum_prize_money = results.map(&:prize_money).inject(:+)
    sum_prize_money ? sum_prize_money / results.size.to_f : 0
  end

  def win_rate(results)
    return 0 if results.empty?

    results.count(&:won).to_f / results.size
  end

  def win_rate_last_four_races(results)
    return 0 if results.empty?

    last_four_races = results.first(4)
    last_four_races.count(&:won).to_f / last_four_races.size
  end
end
