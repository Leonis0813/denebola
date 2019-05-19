class Race < ActiveRecord::Base
  has_many :entries

  def month
    start_time.month
  end
end
