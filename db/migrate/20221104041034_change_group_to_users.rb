class ChangeGroupToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :group_to_users, :uid
  end
end
