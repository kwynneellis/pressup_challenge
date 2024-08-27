class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :start_date, :date
    add_column :users, :current_day, :integer
    add_column :users, :total_press_ups, :integer
    add_column :users, :press_ups_done_today, :integer
  end
end
