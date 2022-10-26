class LeetLogger
    def LeetLogger.get_logger(file_path)
        Logger.new("#{Rails.root}/log/#{file_path}")
    end
end
