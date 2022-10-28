# frozen_string_literal: true

# Description
# Used to redirect to the main page of the website
class MainController < ApplicationController
  layout 'dashboard'

  def dashboard
    if session[:uid].nil?
      flash[:l_notice] = 'Pleases Login Account'
      redirect_to user_index_path type: 'login'
    end
  end
end
