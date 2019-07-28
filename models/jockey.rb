class Jockey < ActiveRecord::Base
  validates :jockey_id,
            presence: {message: 'absent'},
            format: {with: /\A\d+\z/, message: 'invalid'}
end
