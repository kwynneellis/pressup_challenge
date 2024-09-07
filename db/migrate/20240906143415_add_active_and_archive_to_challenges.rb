class AddActiveAndArchiveToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :active, :boolean
    add_column :challenges, :archive, :boolean
  end
end
