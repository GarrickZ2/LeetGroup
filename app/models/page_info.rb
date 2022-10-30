class PageInfo

  def initialize(total_page, total_size, current_page, current_size)
    @total_page = total_page
    @total_size = total_size
    @current_page = current_page
    @current_size = current_size
  end

  attr_accessor :total_page, :total_size, :current_page, :current_size

end
