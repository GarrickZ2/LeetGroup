class CreateGroupWelcomeCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :group_welcome_codes, id: false do |t|
      t.string :code, limit: 10, primary_key: true
      t.integer :gid, limit: 8
      t.integer :uid, limit: 8
      t.integer :type, default: 0
      t.date :expiration_date
    end
  end
end
