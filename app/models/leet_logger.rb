class LeetLogger
  # Description
  # Get the logger used for LeetGroup
  def self.get_logger(class_name = 'Default', file_path = 'other.log')
    logger = Logger.new("#{Rails.root}/log/#{file_path}")
    logger.datetime_format = 'yyyy-MM-dd HH:mm:ss,SSS'
    logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{severity}] #{datetime} #{progname} [#{class_name}]- #{msg}\n"
    end
    logger
  end
end
