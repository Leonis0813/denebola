%w[race entry horse].each {|f| require_relative f }

class Feature < ActiveRecord::Base
  GRADE_LIST = Race::GRADE_LIST + %w[N]

  validates :age, :blank, :burden_weight, :direction, :distance, :distance_diff,
            :entry_times, :grade, :horse_average_prize_money, :horse_id,
            :jockey_average_prize_money, :jockey_win_rate,
            :jockey_win_rate_last_four_races, :last_race_order, :month, :number, :place,
            :race_id, :rate_within_third, :round, :running_style,
            :second_last_race_order, :sex, :track, :weather, :weight, :weight_diff,
            :weight_per, :win_times,
            presence: {message: 'absent'}
  validates :age, :distance, :number, :round,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :distance_diff, :horse_average_prize_money, :jockey_average_prize_money,
            numericality: {greater_than_or_equal_to: 0, message: 'invalid'},
            allow_nil: true
  validates :blank, :entry_times, :last_race_order, :second_last_race_order, :win_times,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :burden_weight, :weight, :weight_per,
            numericality: {greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :direction,
            inclusion: {in: Race::DIRECTION_LIST, message: 'invalid'},
            allow_nil: true
  validates :grade,
            inclusion: {in: GRADE_LIST, message: 'invalid'},
            allow_nil: true
  validates :horse_id, :race_id,
            format: {with: /\A\d+\z/, message: 'invalid'},
            allow_nil: true
  validates :month,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 12,
              message: 'invalid',
            },
            allow_nil: true
  validates :jockey_win_rate, :jockey_win_rate_last_four_races, :rate_within_third,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1,
              message: 'invalid',
            },
            allow_nil: true
  validates :place,
            inclusion: {in: Race::PLACE_LIST, message: 'invalid'},
            allow_nil: true
  validates :running_style,
            inclusion: {in: Horse::RUNNING_STYLE_LIST, message: 'invalid'},
            allow_nil: true
  validates :sex,
            inclusion: {in: Entry::SEX_LIST, message: 'invalid'},
            allow_nil: true
  validates :track,
            inclusion: {in: Race::TRACK_LIST, message: 'invalid'},
            allow_nil: true
  validates :weather,
            inclusion: {in: Race::WEATHER_LIST, message: 'invalid'},
            allow_nil: true
  validates :won,
            inclusion: {in: [true, false], message: 'invalid'},
            allow_nil: true

  after_initialize :set_default_value

  private

  def set_default_value
    self.grade ||= 'N'
  end
end
