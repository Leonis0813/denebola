require 'active_support'

module ArgumentUtil
  cattr_accessor :logger

  module ClassMethods
    def from
      from = ARGV.find {|arg| arg.start_with?('--from=') }
      from ? from.match(/\A--from=(.*)\z/)[1] : nil
    end

    def to
      to = ARGV.find {|arg| arg.start_with?('--to=') }
      to ? to.match(/\A--to=(.*)\z/)[1] : nil
    end

    def operation
      operation = ARGV.find {|arg| arg.start_with?('--operation=') }
      operation ? operation.match(/\A--operation=(.*)\z/)[1] : nil
    end
  end

  extend ClassMethods

  def self.included(klass)
    klass.extend ClassMethods
  end
end
