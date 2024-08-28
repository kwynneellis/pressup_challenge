class LogsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Create a new log entry for the current user
    @log = current_user.logs.build(log_params)

    if @log.save
      # Recalculate the user's total and today's press-ups
      total_done_today = current_user.logs.where(date: Date.today).sum(:press_ups_done)
      current_user.update(
        press_ups_done_today: total_done_today,
        total_press_ups: current_user.total_press_ups + @log.press_ups_done
      )

      # Calculate today's press-ups and the remaining press-ups for today
      @press_ups_today = calculate_press_ups_for_today
      @press_ups_done_today = total_done_today
      @press_ups_remaining_today = [@press_ups_today - @press_ups_done_today, 0].max

      respond_to do |format|
        format.html { redirect_to press_ups_path, notice: 'Press-ups logged successfully!' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'press-ups',
            partial: 'press_ups/press_ups_today',
            locals: { press_ups_today: @press_ups_today,
                      press_ups_done_today: @press_ups_done_today,
                      press_ups_remaining_today: @press_ups_remaining_today }
          )
        end
      end
    else
      redirect_to press_ups_path, alert: 'Failed to log press-ups.'
    end
  end

  def index
    @logs = current_user.logs.order(created_at: :desc)
  end

  private

  def log_params
    params.require(:log).permit(:press_ups_done, :date)
  end

  def calculate_press_ups_for_today
    # Calculate the number of days since the challenge started
    days_since_start = (Date.today - current_user.start_date).to_i + 1
    # The number of press-ups required today is equal to the day of the challenge
    days_since_start
  end
end
