class ApplicationRecord < ActiveRecord::Base
  cattr_accessor :operation

  def self.create_or_update!(record, attribute)
    if record.present? and %w[update upsert].include?(operation)
      record.update!(attribute)
    elsif record.nil? and %w[create upsert].include?(operation)
      record = create!(attribute)
    end

    record
  end

  def self.log_attribute
    {action: operation}
  end
end
