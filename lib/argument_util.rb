module ArgumentUtil
  cattr_accessor :logger

  VALID_OPERATIONS = %w[create update upsert].freeze

  def get_from(default = Date.today - 30)
    from = ARGV.find {|arg| arg.start_with?('--from=') }
    from ? Date.parse(from.match(/\A--from=(.*)$\z/)[1]) : default
  rescue ArgumentError => e
    logger.error(e.backtrace.join("\n"))
    raise
  end

  def get_to(default = Date.today)
    to = ARGV.find {|arg| arg.start_with?('--to=') }
    to ? Date.parse(to.match(/\A--to=(.*)\z/)[1]) : Date.today
  rescue ArgumentError => e
    logger.error(e.backtrace.join("\n"))
    raise
  end

  def get_operation(default = 'create')
    operation = ARGV.find {|arg| arg.start_with?('--operation=') }
    operation ? operation.match(/\A--operation=(.*)\z/)[1] : default
  rescue ArgumentError => e
    logger.error(e.backtrace.join("\n"))
    raise
  end

  def check_operation(operation)
    unless VALID_OPERATIONS.include?(operation)
      logger.error("invalid operation specified: #{operation}")
      raise StandardError
    end
  end
end
