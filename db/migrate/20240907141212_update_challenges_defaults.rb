class UpdateChallengesDefaults < ActiveRecord::Migration[7.0]
  def change
    change_column_default :challenges, :archive, from: false, to: nil
    change_column_default :challenges, :active, from: false, to: false
  end
end
