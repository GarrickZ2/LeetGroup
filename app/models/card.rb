class Card < ActiveRecord::Base
  @@cid = 1
  def self.create_card(uid, title, source, description, schedule_time)
    self.create(uid: uid, title: title, source: source, description: description, schedule_time: schedule_time, status: 0,
                stars: 0, used_time: 0, create_time: Time.now, update_time: NULL, cid: @@cid)
    @@cid += 1
    return @@cid
  end
end