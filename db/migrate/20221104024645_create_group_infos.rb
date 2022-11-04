class CreateGroupInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :group_infos, primary_key: 'gid' do |t|
      t.string :name, limit: 50
      t.string :description, limit: 500
      t.datetime :create_time
      t.integer :status, default: 0
    end
  end
end
