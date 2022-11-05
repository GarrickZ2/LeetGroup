class GroupInfo < ActiveRecord::Base
  @@group_status = { private: 0, public: 1 }
  def self.group_status
    @@group_status
  end
end
