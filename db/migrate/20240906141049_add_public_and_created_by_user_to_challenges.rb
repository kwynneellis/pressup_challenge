class AddPublicAndCreatedByUserToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :public, :boolean, default: false
    add_reference :challenges, :created_by_user_id, foreign_key: { to_table: :users }
  end
end
