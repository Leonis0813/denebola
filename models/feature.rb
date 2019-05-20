%w[race entry horse].each {|f| require_relative f }

class Feature < ActiveRecord::Base
  GRADE_LIST = Race::GRADE_LIST + %w[N]

  validates :age, :average_prize_money, :burden_weight, :distance, :distance_diff,
            :entry_times, :horse_id, :month, :number, :place, :race_id, :round,
            :running_style, :sex, :track, :weather, :win_times,
            presence: {message: 'absent'}
  validates :age, :distance, :number, :round,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'}
  validates :average_prize_money, :distance_diff, :rate_within_third,
            numericality: {greater_than_or_equal_to: 0, message: 'invalid'}
  validates :blank, :last_race_order, :second_last_race_order,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :burden_weight,
            numericality: {greater_than: 0, message: 'invalid'}
  validates :direction,
            inclusion: {in: Race::DIRECTION_LIST, message: 'invalid'},
            allow_nil: true
  validates :entry_times, :win_times,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: 'invalid',
            }
  validates :grade,
            inclusion: {in: GRADE_LIST, message: 'invalid'},
            allow_nil: true
  validates :horse_id, :race_id,
            format: {with: /\A\d+\z/, message: 'invalid'}
  validates :last_race_final_600m_time, :weight, :weight_per,
            numericality: {greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :month,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 12,
              message: 'invalid',
            }
  validates :place,
            inclusion: {in: Race::PLACE_LIST, message: 'invalid'}
  validates :running_style,
            inclusion: {in: Horse::RUNNING_STYLE_LIST, message: 'invalid'}
  validates :sex,
            inclusion: {in: Entry::SEX_LIST, message: 'invalid'}
  validates :track,
            inclusion: {in: Race::TRACK_LIST, message: 'invalid'}
  validates :weather,
            inclusion: {in: Race::WEATHER_LIST, message: 'invalid'}
  validates :won,
            inclusion: {in: [true, false], message: 'invalid'}

  after_initialize :set_default_value

  private

  def set_default_value
    self.grade ||= 'N'
  end
end
