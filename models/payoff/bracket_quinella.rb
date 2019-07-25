# coding: utf-8

class BracketQuinella < Payoff
  validates :bracket_number1,
            :bracket_number2,
            presence: {message: 'absent'},
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            }
end
