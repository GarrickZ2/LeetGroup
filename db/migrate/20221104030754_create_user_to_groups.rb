class CreateUserToGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :user_to_groups, primary_key: [:uid, :gid] do |t|
      t.integer :uid, limit: 8
      t.integer :gid, limit: 8
    end
  end
end
