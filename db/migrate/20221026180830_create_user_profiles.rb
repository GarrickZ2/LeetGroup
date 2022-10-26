class CreateUserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_profiles, primary_key: 'uid' do |t|
      t.string :username, limit: 50
      t.string :school, limit: 50
      t.string :company, limit: 50
      t.string :bio, limit: 200
      t.string :avatar, limit: 100
      t.string :city, limit: 50
      t.date :expiration_date
      t.integer :status, default: 0
    end
  end
end
