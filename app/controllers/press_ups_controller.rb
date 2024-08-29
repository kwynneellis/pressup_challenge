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

  private

  def load_press_up_data(date)
    @press_ups_today = calculate_press_ups_for_date(date)
    @press_ups_done_today = current_user.logs.where(date: date).sum(:press_ups_done)
    @press_ups_remaining_today = [@press_ups_today - @press_ups_done_today, 0].max
    @press_ups_done_today_percentage = (@press_ups_done_today.to_f / @press_ups_today * 100).round(2)
  end

  def calculate_press_ups_for_date(date)
    days_since_start = (date - current_user.start_date).to_i + 1
    days_since_start
  end
  
end