# coding: utf-8
class Feature < ActiveRecord::Base
  validates :age, presence: {message: 'absent'}
  validates :age,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :average_prize_money, presence: {messege: 'absent'}
  validates :average_prize_money,
            numericality: {
              greater_than_or_equal_to: 0,
              message: 'invalid',
            }
  validates :blank,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :burden_weight, presence: {message: 'absent'}
  validates :burden_weight,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            }
  validates :direction, presence: {message: 'absent'}
  validates :direction, inclusion: {in: %w[左 右], message: 'invalid'}
  validates :distance, presence: {messege: 'absent'}
  validates :distance,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :distance_diff, presence: {message: 'absent'}
  validates :distance_diff,
            numericality: {
              greater_than_or_equal_to: 0,
              message: 'invalid',
            }
  validates :entry_times, presence: {message: 'absent'}
  validates :entry_times,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: 'invalid',
            }
  validates :grade,
            inclusion: {
              in: %w[G1 G2 G3 J.G1 J.G2 J.G3 L OP],
              message: 'invalid',
            },
            allow_nil: true
  validates :horse_id, presence: {message: 'absent'}
  validates :horse_id, format: {with: /\A\d+\z/, message: 'invalid'}
  validates :last_race_final_600m_time,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :last_race_order,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :month, presence: {message: 'absent'}
  validates :month,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 12,
              message: 'invalid',
            }
  validates :number, presence: {message: 'absent'}
  validates :number,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :place, presence: {messege: 'absent'}
  validates :place,
            inclusion: {
              in: %w[中京 中山 京都 函館 小倉 新潟 札幌 東京 福島 阪神],
              message: 'invalid',
            }
  validates :race_id, presence: {messege: 'absent'}
  validates :race_id, format: {with: /\A\d+\z/, message: 'invalid'}
  validates :rate_within_third,
            numericality: {
              greater_than_or_equal_to: 0,
              message: 'invalid',
            }
  validates :round, presence: {messege: 'absent'}
  validates :round,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :running_style, presence: {message: 'absent'}
  validates :running_style,
            inclusion: {
              in: %w[逃げ 先行 差し 追込],
              message: 'invalid',
            }
  validates :second_last_race_order,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :sex, presence: {message: 'absent'}
  validates :sex, inclusion: {in: %w[牝 牡], message: 'invalid'}
  validates :track, presence: {messege: 'absent'}
  validates :track, inclusion: {in: %w[芝 ダ], message: 'invalid'}
  validates :weather, presence: {messege: 'absent'}
  validates :weather,
            inclusion: {
              in: %w[晴 曇 小雨 雨 小雪 雪],
              message: 'invalid',
            }
  validates :weight,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :weight_per,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :win_times, presence: {message: 'absent'}
  validates :win_times,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: 'invalid',
            }
  validates :won, presence: {message: 'absent'}
end
