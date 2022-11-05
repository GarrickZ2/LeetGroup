class GroupToUser < ActiveRecord::Base
  @@role_status = { owner: 0, manager: 1, member: 2 }
  def self.role_status
    @@role_status
  end
end
