class Entry < ActiveRecord::Base
  belongs_to :race
  has_one :horse
  has_one :result
end
