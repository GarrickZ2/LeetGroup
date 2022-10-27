describe LeetLogger do

  describe 'test get logger' do
    it 'should create a logger in a file' do
      logger = LeetLogger.get_logger LeetLogger.name, 'test_rspec.log'
      logger.info "test info"
      expect File.exist? 'log/test_rspec.log'
      File.delete 'log/test_rspec.log'
    end
  end
end