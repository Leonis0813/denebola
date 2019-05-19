# coding: utf-8
class Entry < ActiveRecord::Base
  belongs_to :race
  belongs_to :horse

  validates :age, presence: {message: 'absent'}
  validates :age,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :burden_weight, presence: {message: 'absent'}
  validates :burden_weight,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            }
  validates :final_600m_time,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :number, presence: {message: 'absent'}
  validates :number,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :order, presence: {message: 'absent'}
  validates :order,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            }
  validates :prize_money,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true
  validates :sex, presence: {message: 'absent'}
  validates :sex, inclusion: {in: %w[牝 牡], message: 'invalid'}
  validates :weight,
            numericality: {
              greater_than: 0,
              message: 'invalid',
            },
            allow_nil: true

  def weight_per
    return unless burden_weight.to_i.positive? and weight.to_i.positive?

    burden_weight / weight
  end

  def won
    order == '1'
  end
end
