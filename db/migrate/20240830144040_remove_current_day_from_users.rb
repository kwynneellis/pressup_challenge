class RemoveCurrentDayFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :current_day, :integer
  end
end
