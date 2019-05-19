# coding: utf-8

class Race < ActiveRecord::Base
  has_many :entries

  validates :direction, inclusion: {in: %w[左 右], message: 'invalid'}
  validates :distance,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :grade, inclusion: {in: %w[G1 G2 G3], message: 'invalid'}, allow_nil: true
  validates :place,
            inclusion: {
              in: %w[中京 中山 京都 函館 小倉 新潟 札幌 東京 福島 阪神],
              message: 'invalid',
            }
  validates :race_id, format: {with: /\A\d+\z/, message: 'invalid'}
  validates :round,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :track, inclusion: {in: %w[芝 ダ], message: 'invalid'}
  validates :weather, inclusion: {
              in: %w[晴 曇 小雨 雨 小雪 雪],
              message: 'invalid',
            }

  def month
    start_time.month
  end
end
