class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :start_date])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :start_date, :current_day, :total_press_ups, :press_ups_done_today])
  end
end