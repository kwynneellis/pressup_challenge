class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :update_press_ups]

  def show
    @challenge_target_to_date = number_with_delimiter(@user.cumulative_press_up_target_to_date)
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

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :start_date, :total_press_ups)
  end
end