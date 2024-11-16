class AddReminderEmailOptInToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reminder_email_opt_in, :boolean, default: false, null: false
  end
end
