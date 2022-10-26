class UserController < ApplicationController
  def index
    @login_type = params[:type]
    if @login_type == nil || @login_type == ''
      @login_type = 'login'
    end
  end
end
