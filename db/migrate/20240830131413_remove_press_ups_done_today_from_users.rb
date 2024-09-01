class RemovePressUpsDoneTodayFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :press_ups_done_today, :integer
  end
end
