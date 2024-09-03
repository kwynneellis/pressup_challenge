class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]

  def index
    @challenges = current_user.challenges
  end

  def show
  end

  def new
    @challenge = current_user.challenges.new
  end

  def create
    @challenge = current_user.challenges.new(challenge_params)
    if @challenge.save
      redirect_to @challenge, notice: "Challenge created successfully."
    else
      render :new
    end
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to @challenge, notice: "Challenge updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @challenge.destroy
    redirect_to challenges_path, notice: "Challenge deleted successfully."
  end

  private

  def set_challenge
    @challenge = current_user.challenges.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:name)
  end
end