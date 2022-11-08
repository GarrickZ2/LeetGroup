class GroupController < ApplicationController
  def add_card
    res = GroupHelper.add_card_to_group params[:cid], params[:gid]
    if res == false
      flash[:add_notice] = 'This card has been added to this group!'
    end
  end

  def delete_card
    GroupHelper.delete_card_from_group params[:cid], params[:gid]
  end

  def get_all_cards
    GroupHelper.get_card_from_group params[:gid]
  end
end
