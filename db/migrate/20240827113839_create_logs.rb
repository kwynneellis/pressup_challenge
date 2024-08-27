class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :press_ups_done

      t.timestamps
    end
  end
end
