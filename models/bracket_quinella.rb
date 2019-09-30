class BracketQuinella < ActiveRecord::Base
  include PayoffValidator

  belongs_to :race

  validates :bracket_number1,
            :bracket_number2,
            presence: {message: 'absent'}
  validates :bracket_number1,
            :bracket_number2,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            },
            allow_nil: true
end
