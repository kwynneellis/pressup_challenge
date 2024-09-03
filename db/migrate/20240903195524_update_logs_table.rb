class UpdateLogsTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :logs, :date, :date_of_set
    rename_column :logs, :press_ups_done, :reps_in_set

    add_column :logs, :completed_the_day, :boolean, default: false, null: false
  end
end
