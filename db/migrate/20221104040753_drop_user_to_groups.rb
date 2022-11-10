class DropUserToGroups < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_to_groups
  end
end
