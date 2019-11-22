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
    results_before(time).map(&:prize_money).inject(:+) / entry_times(time).to_f
  end

  def win_rate(time)
    results_before(time).select(&:won).size.to_f / entry_times(time)
  end

  def win_rate_last_four_races(time)
    last_four_races = results_before(time).first(4)
    last_four_races.select(&:won).size.to_f / last_four_races.size
  end

  private

  def entry_times(time)
    results_before(time).size
  end

  def results_before(time)
    @results_before ||= results.joins(:race).where('races.start_time <= ?', time)
                               .order('races.start_time desc')
  end
end
