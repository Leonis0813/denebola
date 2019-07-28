# coding: utf-8

class Entry < ActiveRecord::Base
  ORDER_LIST = %w[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 除 中 取 失].freeze
  SEX_LIST = %w[牝 牡 セ].freeze

  belongs_to :race
  belongs_to :horse
  belongs_to :jockey

  validates :age, :burden_weight, :number, :order, :sex,
            presence: {message: 'absent'}
  validates :age, :number,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :burden_weight,
            numericality: {greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :final_600m_time, :weight,
            numericality: {greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :order,
            inclusion: {in: ORDER_LIST, message: 'invalid'},
            allow_nil: true
  validates :prize_money,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :sex,
            inclusion: {in: SEX_LIST, message: 'invalid'},
            allow_nil: true

  def weight_per
    return 0.0 unless burden_weight.to_i.positive? and weight.to_i.positive?

    burden_weight / weight
  end

  def won
    order == '1'
  end
end
