class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  cattr_accessor :operation

  class << self
    def create_or_update!(record, attribute)
      record.update!(attribute) if record.present? and updatable?
      record = create!(attribute) if record.nil? and creatable?
      record
    end

    def creatable?
      %w[create upsert].include?(operation)
    end

    def updatable?
      %w[update upsert].include?(operation)
    end

    def log_attribute
      {action: operation}
    end
  end
end
