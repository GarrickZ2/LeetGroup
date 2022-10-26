class CreateUserLogInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :user_log_infos, id: false do |t|
      t.string :username, limit: 50, primary_key: true
      t.string :password, limit: 50
      t.string :email, limit: 50
      t.integer :uid, limit: 8
    end
  end
end
