describe GroupView do
  it 'initialize group view' do
    view = GroupView.new
    view.count = 20
    expect(view.count).to eql 20
  end
end