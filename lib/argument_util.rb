require 'active_support'

module ArgumentUtil
  VALID_OPERATIONS = %w[create update upsert].freeze

  cattr_accessor :logger

  module ClassMethods
    def from(default = Date.today - 30)
      from = ARGV.find {|arg| arg.start_with?('--from=') }
      from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : default
    end

    def to(default = Date.today)
      to = ARGV.find {|arg| arg.start_with?('--to=') }
      to ? Date.parse(to.match(/\A--to=(.*)\z/)[1]) : default
    end

    def operation(default = 'create')
      operation = ARGV.find {|arg| arg.start_with?('--operation=') }
      operation ? operation.match(/\A--operation=(.*)\z/)[1] : default
    end

    def check_operation(operation)
      return if VALID_OPERATIONS.include?(operation)

      logger.error("invalid operation specified: #{operation}")
      raise StandardError
    end
  end

  extend ClassMethods

  def self.included(klass)
    klass.extend ClassMethods
  end
end
