# coding: utf-8

class Race < ActiveRecord::Base
  has_many :entries

  validates :direction, presence: {message: 'absent'}
  validates :direction, inclusion: {in: %w[左 右], message: 'invalid'}
  validates :distance, presence: {messege: 'absent'}
  validates :distance,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :grade,
            inclusion: {
              in: %w[G1 G2 G3 J.G1 J.G2 J.G3 L OP],
              message: 'invalid',
            },
            allow_nil: true
  validates :place, presence: {messege: 'absent'}
  validates :place,
            inclusion: {
              in: %w[中京 中山 京都 函館 小倉 新潟 札幌 東京 福島 阪神],
              message: 'invalid',
            }
  validates :race_id, presence: {messege: 'absent'}
  validates :race_id, format: {with: /\A\d+\z/, message: 'invalid'}
  validates :round, presence: {messege: 'absent'}
  validates :round,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :track, presence: {messege: 'absent'}
  validates :track, inclusion: {in: %w[芝 ダ], message: 'invalid'}
  validates :weather, presence: {messege: 'absent'}
  validates :weather,
            inclusion: {
              in: %w[晴 曇 小雨 雨 小雪 雪],
              message: 'invalid',
            }

  def month
    start_time.month
  end
end
