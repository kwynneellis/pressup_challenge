class RemoveStartDateAndTotalPressUpsFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :start_date, :date
    remove_column :users, :total_press_ups, :integer
  end
end
