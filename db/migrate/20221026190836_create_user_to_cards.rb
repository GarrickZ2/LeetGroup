class CreateUserToCards < ActiveRecord::Migration[6.0]
  def change
    create_table :user_to_cards do |t|
      t.integer :uid, limit: 8
      t.integer :cid, limit: 8
    end
    add_index(:user_to_cards, :uid)
  end
end
