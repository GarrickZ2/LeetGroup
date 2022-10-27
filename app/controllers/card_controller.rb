class CardController < ApplicationController

  def create
    cid = Card.create_card params[:uid], params[:title], params[:source], params[:description], params[:schedule_time]
    session[:cid] = cid
    redirect_to main_create_card_path
  end
end