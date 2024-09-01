class LogsController < ApplicationController
  before_action :authenticate_user!

  def create
    date = params[:log][:date] || Date.today
    @log = current_user.logs.build(log_params.merge(date: date))

    if @log.save
      current_user.calculate_total_press_ups_done
      redirect_to day_press_ups_path(date: date), notice: 'Press-ups logged successfully!'
    else
      redirect_to day_press_ups_path(date: date), alert: 'Failed to log press-ups.'
    end
  end

  def index
    @logs = current_user.logs.order(created_at: :desc)
  end

  def reset_logs
    date = params[:date] || Date.today
    day_logs = current_user.logs.where(date: date)

    if day_logs.exists?
      day_logs.destroy_all
      current_user.calculate_total_press_ups_done
      redirect_to day_press_ups_path(date: date), notice: "#{date}'s logs have been reset."
    else
      redirect_to day_press_ups_path(date: date), alert: "No logs to reset for #{date}."
    end
  end

  def update_all_logs
    current_user.transaction do
      current_user.logs.destroy_all # Delete all existing logs

      current_user.start_date.upto(Date.today) do |date|
        press_ups_target = current_user.press_up_target_for(date)
        current_user.logs.create!(date: date, press_ups_done: press_ups_target)
      end
    end

    current_user.calculate_total_press_ups_done
    redirect_to user_path(current_user), notice: "Your logs have been updated to be up-to-date."
  rescue => e
    redirect_to user_path(current_user), alert: "There was an error updating your logs: #{e.message}"
  end

  private

  def log_params
    params.require(:log).permit(:press_ups_done, :date)
  end
end