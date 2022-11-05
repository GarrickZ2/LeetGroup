class CreateGroupToCards < ActiveRecord::Migration[6.0]
  def change
    create_table :group_to_cards, primary_key: [:gid, :cid] do |t|
      t.integer :gid, limit: 8
      t.integer :cid, limit: 8
    end
  end
end
