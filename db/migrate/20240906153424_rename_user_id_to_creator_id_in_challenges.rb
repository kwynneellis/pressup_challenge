class RenameUserIdToCreatorIdInChallenges < ActiveRecord::Migration[7.0]
  def change
    rename_column :challenges, :user_id, :creator_id
    remove_column :challenges, :created_by_user_id
  end
end
