class CreateCardToComments < ActiveRecord::Migration[6.0]
  def change
    create_table :card_to_comments, id: false do |t|
      t.integer :cid, limit: 8
      t.integer :uid, limit: 8
      t.integer :comment_id, limit: 8, primary_key: true
      t.string :content, limit: 500
      t.datetime :create_time
      t.index :cid
    end
  end
end
