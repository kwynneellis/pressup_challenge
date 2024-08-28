class PressUpsController < ApplicationController
  before_action :authenticate_user!

  def index
    @press_ups_today = calculate_press_ups_for_today
    @press_ups_done_today = current_user.logs.where(date: Date.today).sum(:press_ups_done)
    @press_ups_remaining_today = [@press_ups_today - @press_ups_done_today, 0].max
    @press_ups_done_today_percentage = (@press_ups_done_today.to_f / @press_ups_today * 100).round(2)
  end

  private

  def calculate_press_ups_for_today
    # Calculate the number of days since the challenge started
    days_since_start = (Date.today - current_user.start_date).to_i + 1
    # The number of press-ups required today is equal to the day of the challenge
    days_since_start
  end
end