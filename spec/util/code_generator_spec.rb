describe CodeGenerator do
  describe 'get a random code with length 6' do
    it 'generate a invite code' do
      code = CodeGenerator.generate
      expect(code.length).to eql 6
    end
  end
end
