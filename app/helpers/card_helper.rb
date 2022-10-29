module CardHelper
  def self.check_title_empty(title)
    !title.empty?
  end

  def self.check_title_length(title)
    title.size <= 50
  end

  def self.check_source_length(source)
    source.size <= 100
  end

  def self.check_description_length(description)
    description.size <= 300
  end

  def self.create_card(uid, title, source, description)
    cid = Card.create_card(uid, title, source, description)
    UserToCard.create(uid: uid, cid:cid)
    return true
  end
end
