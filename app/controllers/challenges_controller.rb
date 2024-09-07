class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:show, :join, :leave, :show_by_date, :edit, :update, :destroy]

  def index
    @challenges = current_user.joined_challenges
  end

  def public_index
    # Get all public challenges
    all_public_challenges = Challenge.where(public: true)
  
    # Exclude challenges that the current user has already joined
    @public_challenges = all_public_challenges.reject do |challenge|
      current_user.participating_in?(challenge.id)
    end
  end

  def join
    # Check if the challenge is not archived
    if !@challenge.archive?
      
      # Check if the user has already joined the challenge
      if current_user.participating_in?(@challenge)
        redirect_to @challenge, alert: "You have already joined this challenge."
      else
        Participation.create(user: current_user, challenge: @challenge)
        redirect_to @challenge, notice: "You have successfully joined the challenge!"
      end
  
    else
      redirect_to challenges_path, alert: "This challenge is no longer available to join."
    end
  end

  def leave
    participation = Participation.find_by(user: current_user, challenge: @challenge)

    if participation
      participation.destroy
      redirect_to challenges_path, notice: "You have left the challenge."
    else
      redirect_to @challenge, alert: "You are not participating in this challenge."
    end
  end

  def show
    @date = Date.today
    load_log_data_for(@date)
    # Allow users to see the show page if they created the challenge or have joined it
    unless @challenge.public? || @challenge.creator == current_user || @challenge.participations.exists?(user: current_user)
      redirect_to challenges_path, alert: "You do not have permission to view this challenge."
    end
  end

  def show_by_date
    @date = params[:date].to_date
    load_log_data_for(@date)
    render :show
  end

  def day
    @date = params[:date]&.to_date || Date.today
    load_log_data_for(@date)

    respond_to do |format|
      format.html { render :day }
      format.turbo_stream { render_turbo_stream_response(@date) }
    end
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = current_user.created_challenges.new(challenge_params)

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
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:name, :start_date, :challenge_type, :public)
  end

  def load_log_data_for(date)
    @rep_target = @challenge.rep_target_for(date)
    @reps_done = @challenge.reps_done_on(date)
    @reps_remaining = [@rep_target - @reps_done, 0].max
    @reps_done_as_percentage = (@reps_done.to_f / @rep_target * 100).round(2)
  end

  def render_turbo_stream_response(date)
    render turbo_stream: [
      turbo_stream.replace("challenge-#{challenge.id}-#{date}", partial: 'challenges/on_date', locals: {
        rep_target: @rep_target,
        reps_done: @reps_done,
        reps_remaining: @reps_remaining,
        reps_done_as_percentage: @reps_done_as_percentage
      }),
      turbo_stream.replace('log-all-reps', partial: 'challenges/log_all_button', locals: { reps_remaining: @preps_remaining })
    ]
  end
end