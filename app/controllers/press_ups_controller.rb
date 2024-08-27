class PressUpsController < ApplicationController
  before_action :authenticate_user!

  def index
    @press_ups_today = calculate_press_ups_for_today
  end

  private

  def calculate_press_ups_for_today
    # Calculate the number of days since the challenge started
    days_since_start = (Date.today - current_user.start_date).to_i + 1
    # The number of press-ups required today is equal to the day of the challenge
    days_since_start
  end
end