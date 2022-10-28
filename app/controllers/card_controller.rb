class CardController < ApplicationController

  def create
    unless CardHelper.check_title_empty params[:title]
      flash[:r_notice] = 'Title cannot be empty'
      redirect_to
      return
    end
    unless CardHelper.check_title_length params[:title]
      flash[:r_notice] = 'The maximum length cannot exceed 50 characters'
      redirect_to
      return
    end
    unless CardHelper.check_source_length params[:source]
      flash[:r_notice] = 'The maximum length cannot exceed 100 characters'
      redirect_to
      return
    end
    unless CardHelper.check_description_length params[:description]
      flash[:r_notice] = 'The maximum length cannot exceed 300 characters'
      redirect_to
      return
    end
    CardHelper.create_card params[:uid], params[:title], params[:source], params[:description]
    redirect_to
  end
end
