class GroupWelcomeCode < ActiveRecord::Base
  @@welcome_type = { private: 0, public: 1 }
  def self.welcome_type
    @@welcome_type
  end
end

