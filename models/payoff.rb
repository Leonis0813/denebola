# coding: utf-8

class Payoff < ActiveRecord::Base
  belongs_to :race

  validates :odds, :favorite,
            presence: {message: 'absent'}
  validates :odds,
            numericality: {greater_than: 1, message: 'invalid'}
  validates :favorite,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            }
end
