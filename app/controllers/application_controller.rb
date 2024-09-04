class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_info, if: :user_signed_in?

  private

  def set_info
    date = params[:date]&.to_date || Date.today
    @challenge_count = current_user.challenges.count
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end