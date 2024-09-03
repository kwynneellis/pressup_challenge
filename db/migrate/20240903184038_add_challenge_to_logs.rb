class AddChallengeToLogs < ActiveRecord::Migration[7.0]
  def change
    add_reference :logs, :challenge, null: true, foreign_key: true
    remove_reference :logs, :user, foreign_key: true
  end
end
