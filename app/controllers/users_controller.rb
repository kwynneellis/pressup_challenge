class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :toggle_visibility]

  def show
    @all_challenges = (@user.joined_challenges + @user.created_challenges).uniq
    # Ensure each challenge is up-to-date
    @all_challenges.each do |challenge|
      challenge.set_active_and_archive
      challenge.save if challenge.changed? # Only save if changes occurred
    end

    # Challenges that are active and joined
    @active_challenges = @user.joined_challenges.active

    # Created challenges that are not in the active challenges
    @created_non_active_challenges = @user.created_challenges.where.not(id: @active_challenges.pluck(:id))

    # Archived challenges, whether joined or created
    @archived_challenges = (@user.joined_challenges.archived + @user.created_challenges.archived).uniq
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
    params.require(:user).permit(:username)
  end
end