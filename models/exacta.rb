class Exacta < ActiveRecord::Base
  include PayoffValidator

  belongs_to :race

  validates :first_place_number,
            :second_place_number,
            presence: {message: 'absent'}
  validates :first_place_number,
            :second_place_number,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              message: 'invalid',
            },
            allow_nil: true

  def self.table_name
    'exactas'
  end
end
