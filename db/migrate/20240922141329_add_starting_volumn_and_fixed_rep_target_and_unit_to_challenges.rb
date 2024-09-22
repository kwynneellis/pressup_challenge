class AddStartingVolumnAndFixedRepTargetAndUnitToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :starting_volume, :integer
    add_column :challenges, :fixed_rep_target, :integer
    add_column :challenges, :rep_unit, :string
  end
end
