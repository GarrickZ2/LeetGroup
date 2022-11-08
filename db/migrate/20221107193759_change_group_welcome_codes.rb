class ChangeGroupWelcomeCodes < ActiveRecord::Migration[6.0]
  def change
    rename_column :group_welcome_codes, :type, :status
  end
end
