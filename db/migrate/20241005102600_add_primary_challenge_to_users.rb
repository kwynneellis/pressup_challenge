class AddPrimaryChallengeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :primary_challenge, foreign_key: { to_table: :challenges }, index: true
  end
end
