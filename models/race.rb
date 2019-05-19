# coding: utf-8

class Race < ActiveRecord::Base
  DIRECTION_LIST = %w[左 右]
  GRADE_LIST = %w[G1 G2 G3 J.G1 J.G2 J.G3 L OP]
  PLACE_LIST = %w[中京 中山 京都 函館 小倉 新潟 札幌 東京 福島 阪神]
  TRACK_LIST = %w[芝 ダ]
  WEATHER_LIST = %w[晴 曇 小雨 雨 小雪 雪]

  has_many :entries

  validates :direction, :distance, :place, :race_id, :round, :track, :weather,
            presence: {message: 'absent'}
  validates :direction,
            inclusion: {in: DIRECTION_LIST, message: 'invalid'}
  validates :distance, :round
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'}
  validates :grade,
            inclusion: {in: GRADE_LIST, message: 'invalid'}
            allow_nil: true
  validates :place,
            inclusion: {in: PLACE_LIST, message: 'invalid'}
  validates :race_id,
            format: {with: /\A\d+\z/, message: 'invalid'}
  validates :track,
            inclusion: {in: TRACK_LIST, message: 'invalid'}
  validates :weather,
            inclusion: {in: WEATHER_LIST, message: 'invalid'}

  def month
    start_time.month
  end
end
