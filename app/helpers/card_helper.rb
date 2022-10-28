module CardHelper
  def check_title_empty(title)
    if title.empty?
      false
    else
      true
    end
  end

  def check_title_length(title)
    title.size <= 50
  end

  def check_source_length(source)
    source.size <= 100
  end

  def check_description_length(description)
    description.size <= 300
  end

  def create_card(uid, title, source, description)
    cid = Card.create_card params[:uid], params[:title], params[:source], params[:description]
    UserToCard.create_user_to_card params[:uid], params[cid]
  end
end
