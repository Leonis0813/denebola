# coding: utf-8

class Trifecta < Payoff
  validates :first_place_number,
            :second_place_number,
            :third_place_number,
            presence: {message: 'absent'},
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            }
end
