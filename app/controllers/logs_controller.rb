class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_press_up_stats, only: [:create, :reset_logs]
  before_action :render_turbo_stream_response, only: [:create, :reset_logs], if: -> { request.format.turbo_stream? }

  def create
    @log = current_user.logs.build(log_params)

    if @log.save
      update_user_press_up_stats(@log.press_ups_done)
      respond_to do |format|
        format.html { redirect_to press_ups_path, notice: 'Press-ups logged successfully!' }
      end
    else
      redirect_to press_ups_path, alert: 'Failed to log press-ups.'
    end
  end

  def index
    @logs = current_user.logs.order(created_at: :desc)
  end

  def reset_logs
    today_logs = current_user.logs.where(date: Date.today)

    if today_logs.exists?
      today_logs.destroy_all
      update_user_press_up_stats(0, reset: true)
      respond_to do |format|
        format.html { redirect_to press_ups_path, notice: "Today's logs have been reset." }
      end
    else
      redirect_to press_ups_path, alert: "No logs to reset for today."
    end
  end

  private

  def log_params
    params.require(:log).permit(:press_ups_done, :date)
  end

  def calculate_press_ups_for_today
    (Date.today - current_user.start_date).to_i + 1
  end

  def update_user_press_up_stats(press_ups_done, reset: false)
    if reset
      @press_ups_done_today = 0
    else
      @press_ups_done_today = current_user.logs.where(date: Date.today).sum(:press_ups_done)
    end

    @press_ups_today = calculate_press_ups_for_today
    @press_ups_remaining_today = [@press_ups_today - @press_ups_done_today, 0].max

    current_user.update(
      press_ups_done_today: @press_ups_done_today,
      total_press_ups: reset ? current_user.total_press_ups - press_ups_done : current_user.total_press_ups + press_ups_done
    )
  end

  def render_turbo_stream_response
    render turbo_stream: [
      turbo_stream.replace('press-ups', partial: 'press_ups/press_ups_today', locals: { press_ups_today: @press_ups_today, press_ups_done_today: @press_ups_done_today, press_ups_remaining_today: @press_ups_remaining_today }),
      turbo_stream.replace('log-all-press-ups', partial: 'press_ups/log_all_button', locals: { press_ups_remaining_today: @press_ups_remaining_today })
    ]
  end

  def set_press_up_stats
    @press_ups_today = calculate_press_ups_for_today
    @press_ups_done_today = current_user.logs.where(date: Date.today).sum(:press_ups_done)
    @press_ups_remaining_today = [@press_ups_today - @press_ups_done_today, 0].max
  end
end