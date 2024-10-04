class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :toggle_visibility]

  def show
    @challenges = @user.joined_challenges
    @created_challenges = @user.created_challenges
  end

  def edit
  end

  def toggle_visibility
    @user.update(visibility: !@user.visibility)
    redirect_to edit_user_registration_path, notice: 'Visibility updated successfully.'
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
    # TODO: Remove :total_press_ups, :start_date
    params.require(:user).permit(:username)
  end
end