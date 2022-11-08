class CardToCommentController < ApplicationController
  def add
    if_add = CardToComment.add_comment params[:uid], params[:cid], params[:content]
    if if_add == false
      render json: { success: false, msg: 'content exceeds 500 characters' }
    else
      render json: { success: true, msg: 'successfully add the comment' }
    end
  end

  def delete
    if_delete = CardToComment.delete_comment params[:uid], params[:comment_id]
    case if_delete
    when 0
      render json: { success: false, msg: 'the comment does not exist' }
      return
    when 1
      render json: { success: false, msg: 'fail to delete as the user is not the card owner' }
      return 
    else
      render json: { success: true, msg: 'successfully delete the comment' }
      return
    end
  end

  def show
    comments = CardToCommentHelper.show_comment params[:cid]
    render json: { comments: comments }
  end
end