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
    cid = Card.create_card(uid, title, source, description)
    UserToCard.create_user_to_card(uid, cid)
  end
end
