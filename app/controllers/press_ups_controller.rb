class PressUpsController < ApplicationController
  before_action :authenticate_user!

  def index
    @date = Date.today
    load_press_up_data(@date)
  end

  def show_by_date
    @date = params[:date].to_date
    load_press_up_data(@date)
    render :index
  end

  def day
    @date = params[:date]&.to_date || Date.today
    load_press_up_data(@date)

    respond_to do |format|
      format.html { render :day }
      format.turbo_stream { render_turbo_stream_response(@date) }
    end
  end

  private

  def load_press_up_data(date)
    @press_up_target = current_user.press_up_target_for(date)
    @press_ups_done = current_user.logs.where(date_of_set: date).sum(:reps_in_set)
    @press_ups_remaining = [@press_up_target - @press_ups_done, 0].max
    @press_ups_done_as_percentage = (@press_ups_done.to_f / @press_up_target * 100).round(2)
  end

  def render_turbo_stream_response(date)
    render turbo_stream: [
      turbo_stream.replace("press-ups-#{date}", partial: 'press_ups/on_date', locals: {
        press_ups_target: @press_up_target,
        press_ups_done: @press_ups_done,
        press_ups_remaining: @press_ups_remaining,
        press_ups_done_as_percentage: @press_ups_done_as_percentage
      }),
      turbo_stream.replace('log-all-press-ups', partial: 'press_ups/log_all_button', locals: { press_ups_remaining: @press_ups_remaining })
    ]
  end
end