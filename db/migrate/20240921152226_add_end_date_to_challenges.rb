class AddEndDateToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :end_date, :date
  end
end
