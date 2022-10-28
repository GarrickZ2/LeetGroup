class CardController < ApplicationController
  def create
    unless CardHelper.check_title_empty params[:title]
      render json: { success: false, msg: 'Title cannot be empty' }
      return
    end
    unless CardHelper.check_title_length params[:title]
      render json: { success: false, msg: 'The maximum length of title cannot exceed 50 characters' }
      return
    end
    unless CardHelper.check_source_length params[:source]
      render json: { success: false, msg: 'The maximum length of source cannot exceed 100 characters' }
      return
    end
    unless CardHelper.check_description_length params[:description]
      render json: { success: false, msg: 'The maximum length of description cannot exceed 300 characters' }
      return
    end
    CardHelper.create_card params[:uid], params[:title], params[:source], params[:description]
    render json: { success: true, msg: nil }
  end
end
