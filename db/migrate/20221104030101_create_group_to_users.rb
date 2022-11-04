class CreateGroupToUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :group_to_users, primary_key: [:gid, :uid] do |t|
      t.integer :gid, limit: 8
      t.integer :uid, limit: 8
      t.integer :role, default: 0
    end
  end
end
