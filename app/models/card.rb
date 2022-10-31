class Card < ActiveRecord::Base
  def self.create_card(uid, title, source, description)
    new_card = create(uid: uid, title: title, source: source, description: description, schedule_time: nil, status: 0,
                      stars: 0, used_time: 0, create_time: Time.now, update_time: Time.now)
    new_card.cid
  end

  def self.view_card(uid, status, page_size, offset, sort_by, sort_type)
    @cards = Card.where(uid: uid)
    @cards = @cards.where(status: status) unless status == 3

    if !sort_by.nil? && sort_type == 'asc'
      @cards = @cards.order(sort_by => :asc)
    end
    if !sort_by.nil? && sort_type == 'desc'
      @cards = @cards.order(sort_by => :desc)
    end

    total_size = @cards.count

    @cards = @cards.limit(page_size).offset(offset * page_size)

    total_page = total_size / page_size
    if total_size % page_size != 0
      total_page += 1
    end
    current_size = if total_size.zero?
                     0
                   elsif offset == total_page - 1
                     total_size - (total_page - 1) * page_size
                   else
                     page_size
                   end

    page_info = PageInfo.new(total_page, total_size, offset, current_size)
    CardView.new(page_info, @cards)
  end


  def self.view_card_detail(cid, uid)
    if Card.find_by_uid(uid).nil?
      nil
    else
      Card.find_by(uid: uid, cid: cid)
    end
  end
end
