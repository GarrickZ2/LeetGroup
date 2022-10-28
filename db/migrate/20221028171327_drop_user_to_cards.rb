class DropUserToCards < ActiveRecord::Migration[6.0]
  def up
    drop_table :user_to_cards
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
