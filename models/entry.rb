class Entry < ActiveRecord::Base
  belongs_to :race
  belongs_to :horse

  def weight_per
    return unless burden_weight.to_i.positive? and weight.to_i.positive?

    burden_weight / weight
  end

  def won
    order == '1'
  end
end
