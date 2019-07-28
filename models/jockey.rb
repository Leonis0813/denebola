class Jockey < ActiveRecord::Base
  has_many :results, class_name: 'Entry'

  validates :jockey_id,
            presence: {message: 'absent'},
            format: {with: /\A\d+\z/, message: 'invalid'}

  def average_prize_money(time)
    results_before(time).map(&:prize_money).inject(:+) / entry_times(time).to_f
  end

  def win_rate(time)
    win_times(time).to_f / entry_times(time)
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
