class CardToCommentController < ApplicationController
  def add
    if_add = CardToComment.add_comment params[:uid], params[:cid], params[:content]
    if !if_add
      render json: { success: false, msg: 'content exceeds 500 characters' }
    else
      render json: { success: true, msg: 'successfully add the comment' }
    end
  end

  def show
    comments = CardToCommentHelper.show_comment params[:cid]
    render json: { comments: comments }
  end
end
