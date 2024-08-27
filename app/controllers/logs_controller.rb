class LogsController < ApplicationController
  before_action :authenticate_user!

  def create
    @log = current_user.logs.build(log_params)
    if @log.save
      current_user.update(
        press_ups_done_today: current_user.press_ups_done_today + @log.press_ups_done,
        total_press_ups: current_user.total_press_ups + @log.press_ups_done
      )
      redirect_to press_ups_path, notice: 'Press-ups logged successfully!'
    else
      redirect_to press_ups_path, alert: 'Failed to log press-ups.'
    end
  end

  def index
    @logs = current_user.logs.order(created_at: :desc)
  end

  private

  def log_params
    params.require(:log).permit(:press_ups_done)
  end
end