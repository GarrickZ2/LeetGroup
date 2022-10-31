class Card < ActiveRecord::Base
  def self.create_card(uid, title, source, description)
    new_card = create(uid: uid, title: title, source: source, description: description, schedule_time: nil, status: 0,
                      stars: 0, used_time: 0, create_time: Time.now, update_time: Time.now)
    new_card.cid
  end

  def self.view_card_detail(cid, uid)
    if Card.find_by_uid(uid).nil?
      nil
    else
      Card.find_by(uid: uid, cid: cid)
    end
  end
end
