class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_info, if: :user_signed_in?

  private

  def set_info
    date = params[:date]&.to_date || Date.today
    joined_challenges = current_user.joined_challenges
    @todays_target = joined_challenges.first&.rep_target_for(Date.today) || ''
    @primary_challenge = joined_challenges.first || ''
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end