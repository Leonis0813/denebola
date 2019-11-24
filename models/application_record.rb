class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  cattr_accessor :operation

  def self.create_or_update!(record, attribute)
    if record.present? and %w[update upsert].include?(operation)
      record.update!(attribute)
    elsif record.nil? and %w[create upsert].include?(operation)
      record = create!(attribute)
    end

    record
  end

  def creatable?
    %w[create upsert].include?(self.class.operation)
  end

  def updatable?
    %w[update upsert].include?(self.class.operation)
  end

  def self.log_attribute
    {action: operation}
  end
end
