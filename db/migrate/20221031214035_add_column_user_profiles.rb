class AddColumnUserProfiles < ActiveRecord::Migration[6.0]
  def change
    change_table :user_profiles do |t|
      t.string :role, limit: 50
    end
  end
end
