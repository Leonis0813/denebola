require 'active_support'

module PayoffValidator
  extend ActiveSupport::Concern

  included do
    validates :odds, :favorite,
              presence: {message: 'absent'}
    validates :odds,
              numericality: {greater_than_or_equal_to: 1, message: 'invalid'}
    validates :favorite,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 1,
                message: 'invalid',
              }
  end
end
