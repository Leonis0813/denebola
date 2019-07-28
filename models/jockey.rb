class Jockey < ActiveRecord::Base
  has_many :results, class_name: 'Entry'

  validates :jockey_id,
            presence: {message: 'absent'},
            format: {with: /\A\d+\z/, message: 'invalid'}
end
