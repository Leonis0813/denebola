require_relative 'application_record'

class Show < ApplicationRecord
  include PayoffValidator

  belongs_to :race

  validates :number,
            presence: {message: 'absent'}
  validates :number,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            },
            allow_nil: true
end
