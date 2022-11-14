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

  def view
    card_view = Card.view_card params[:uid], params[:status].to_i, params[:page_size].to_i, params[:offset].to_i, params[:sort_by],
                               params[:sort_type]

    page_info = card_view.page_info.to_json
    card_info = card_view.card_info
    cards = []
    card_info.each { |card|
      cards.append(card.to_json)
    }
    render json: { card_info: cards, page_info: page_info}
  end

  def view_card_detail
    card_detail = Card.view_card_detail params[:cid], params[:uid]
    render json: { card: card_detail }
  end

  # post /card/:cid/edit
  # params: uid, title, source, description
  # return: json { success: bool, msg: string }
  def edit
    card = Card.new
    card.uid = params[:uid]
    card.cid = params[:cid]
    card.title = params[:title]
    card.source = params[:source]
    card.description = params[:description]
    res = CardHelper.update_card card
    message = 'Update the profile successfully'
    unless res
      message = 'Update the profile failed'
    end
    render json: { success: res, msg: message }
  end

  def delete
    p params
    uid = params[:uid]
    cid = params[:cid]
    res = CardHelper.delete_card uid, cid
    unless res
      # flash[:main_notice] = 'Delete card failed'
      # redirect_to '/main/all_cards.html'
      render json: { success: false, msg: "The card doesn't exist" }
      return
    end
    # flash[:main_notice] = 'Delete card successfully'
    # redirect_to '/main/all_cards.html'
    render json: { success: true, msg: 'The card deleted successfully' }
  end

  # post /card/:cid/share
  # params: list of :gid
  # return: json { success: bool, msg: string }
  def share
    cid = params[:cid]
    gid_list = params[:gid_list]
    gid_list.each { |gid|
      CardHelper.share_card gid, cid
    }
    render json: { success: true, msg: 'The card is shared successfully' }
  end

  # post /card/:cid/check_exist
  # params: list of :gid
  # return: exist_list: list of gids that contain the card
  def check_card_exist
    cid = params[:cid]
    gid_list = params[:gid_list]
    exist_list = []
    gid_list.each { |gid|
      if GroupToCard.exists?(gid: gid, cid: cid)
        exist_list.append(gid)
      end
    }
    render json: {success: true, exist_list: exist_list}
  end
end
