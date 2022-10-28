class CardController < ApplicationController
  def create
    render json: { success: false, msg: 'Title cannot be empty' } unless CardHelper.check_title_empty params[:title]
    unless CardHelper.check_title_length params[:title]
      render json: { success: false, msg: 'The maximum length cannot exceed 50 characters' }
    end
    unless CardHelper.check_source_length params[:source]
      render json: { success: false, msg: 'The maximum length cannot exceed 100 characters' }
    end
    unless CardHelper.check_description_length params[:description]
      render json: { success: false, msg: 'The maximum length cannot exceed 300 characters' }
    end
    CardHelper.create_card params[:uid], params[:title], params[:source], params[:description]
    render json: { success: true, msg: nil }
  end
end
