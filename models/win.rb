class Win < ActiveRecord::Base
  include PayoffValidator

  belongs_to :race

  validates :number,
            presence: {message: 'absent'},
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            }
end
