class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_press_up_target

  private

  def set_press_up_target
    date = params[:date]&.to_date || Date.today
    @press_ups_target = number_with_delimiter(current_user.press_up_target_for(date))
    @cumulated_press_ups = number_with_delimiter(current_user.total_press_ups)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :start_date])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :start_date, :total_press_ups])
  end
end