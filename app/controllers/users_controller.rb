class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :update_press_ups]

  def show
    @challenge_to_date = calculate_total_press_ups_to_date
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  def update_press_ups
    @user.total_press_ups = calculate_total_press_ups_to_date
    if @user.save
      redirect_to user_path, notice: "Your total press-ups have been updated to the current date."
    else
      redirect_to user_path, alert: "There was a problem updating your total press-ups."
    end
  end

  private

  def calculate_total_press_ups_to_date
    # Calculate the total press-ups the user should have done from their start date to today
    days_since_start = (Date.today - @user.start_date).to_i + 1
    (days_since_start * (days_since_start + 1)) / 2
  end

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :start_date, :current_day, :total_press_ups, :press_ups_done_today)
  end
end