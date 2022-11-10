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
  def edit
    render json: { success: true, msg: nil }
  end

  def delete
    uid = params[:uid]
    cid = params[:cid]
    res = CardHelper.delete_card uid, cid
    unless res
      render json: { success: false, msg: "The card doesn't exist" }
      return
    end
    render json: { success: true, msg: nil }
  end
end
