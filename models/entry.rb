# coding: utf-8
class Entry < ActiveRecord::Base
  SEX_LIST = %w[牝 牡]

  belongs_to :race
  belongs_to :horse

  validates :age, :burden_weight, :number, :order, :sex,
            presence: {message: 'absent'}
  validates :age, :number, :order,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'}
  validates :burden_weight,
            numericality: {greater_than: 0, message: 'invalid'}
  validates :final_600m_time, :weight,
            numericality: {greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :prize_money,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :sex, inclusion: {in: SEX_LIST, message: 'invalid'}

  def weight_per
    return unless burden_weight.to_i.positive? and weight.to_i.positive?

    burden_weight / weight
  end

  def won
    order == '1'
  end
end
