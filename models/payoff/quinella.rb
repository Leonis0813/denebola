# coding: utf-8

class Quinella < Payoff
  validates :number1, :number2,
            presence: {message: 'absent'},
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            }
end
