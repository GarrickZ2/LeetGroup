class MainController < ApplicationController
  layout "dashboard"

  def dashboard
    # for testing
    session[:uid] = 20
    render 'main/dashboard'
  end
end
