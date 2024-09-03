class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :challenges do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.string :challenge_type

      t.timestamps
    end
  end
end
