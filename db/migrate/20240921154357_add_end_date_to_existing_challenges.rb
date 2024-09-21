class AddEndDateToExistingChallenges < ActiveRecord::Migration[7.0]
  def up
    Challenge.update_all(end_date: Date.new(Date.today.year, 12, 31))
  end

  def down
    Challenge.update_all(end_date: nil)
  end
end
