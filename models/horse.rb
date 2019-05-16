class Horse < ActiveRecord::Base
  has_many :results, class_name: 'Entry'
end
