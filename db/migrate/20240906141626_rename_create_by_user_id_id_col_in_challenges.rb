class RenameCreateByUserIdIdColInChallenges < ActiveRecord::Migration[7.0]
  def change
    rename_column :challenges, :created_by_user_id_id, :created_by_user_id
  end
end
