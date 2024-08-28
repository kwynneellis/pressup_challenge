class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_press_ups_today

  private

  def set_press_ups_today
    if user_signed_in?
      @press_ups_today = calculate_press_ups_for_today
    end
  end

  def calculate_press_ups_for_today
    # Ensure current_user is defined
    if current_user
      # Calculate the number of press-ups required today
      days_since_start = (Date.today - current_user.start_date).to_i + 1
      days_since_start
    else
      0
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :start_date])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :start_date, :current_day, :total_press_ups, :press_ups_done_today])
  end
end