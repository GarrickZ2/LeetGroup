class GroupToUser < ActiveRecord::Base
  self.primary_keys = :gid, :uid
  @@role_status = { owner: 0, manager: 1, member: 2, restricted: 3 }
  def self.role_status
    @@role_status
  end
end
