class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards, primary_key: 'cid' do |t|
      t.integer :uid, limit: 8
      t.string :title, limit: 80
      t.string :source, limit: 100
      t.string :description, limit: 300
      t.integer :status, default: 0
      t.integer :used_time, limit: 8
      t.integer :stars
      t.datetime :create_time
      t.datetime :update_time
      t.datetime :schedule_time
    end
  end
end
