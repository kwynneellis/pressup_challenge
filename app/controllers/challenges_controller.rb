class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:show, :join, :leave, :show_by_date, :edit, :update, :destroy, :set_primary, :remove_primary]

  def index
    @all_challenges = (current_user.joined_challenges + current_user.created_challenges).uniq
    # Ensure each challenge is up-to-date
    @all_challenges.each do |challenge|
      challenge.set_active_and_archive
      challenge.save if challenge.changed? # Only save if changes occurred
    end

    # Challenges that are active and joined
    @active_challenges = current_user.joined_challenges.active

    # Created challenges that are not in the active challenges
    @created_non_active_challenges = current_user.created_challenges.where.not(id: @active_challenges.pluck(:id))

    # Archived challenges, whether joined or created
    @archived_challenges = (current_user.joined_challenges.archived + current_user.created_challenges.archived).uniq
  end

  def public_index
    # Get all public challenges
    all_public_challenges = Challenge.where(public: true)
  
    # Exclude challenges that the current user has already joined
    @public_challenges = all_public_challenges.reject do |challenge|
      current_user.participating_in?(challenge)
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
    Participation.create(user: current_user, challenge: @challenge)

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

  def set_primary
    current_user.set_primary_challenge(@challenge)
    redirect_to @challenge, notice: "Primary challenge updated!"
  end

  def remove_primary
    current_user.remove_primary_challenge
    redirect_to @challenge, notice: "Primary challenge removed, default set!"
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:name, :start_date, :end_date, :challenge_type, :starting_volume, :fixed_rep_target, :rep_unit, :public)
  end

  def load_log_data_for(date)
    @log_increments = [1,5,10,25,50,100]
    @rep_target = @challenge.rep_target_for(date)
    @reps_done = @challenge.reps_done_on(date, current_user)
    @reps_remaining = [@rep_target - @reps_done, 0].max
    @reps_done_as_percentage = (@reps_done.to_f / @rep_target * 100).round(2)
  end

  def render_turbo_stream_response(date)
    render turbo_stream: [
      turbo_stream.replace("challenge-#{challenge.id}-#{date}", partial: 'challenges/daily_progress_bar', locals: {
        rep_target: @rep_target,
        reps_done: @reps_done,
        reps_remaining: @reps_remaining,
        reps_done_as_percentage: @reps_done_as_percentage
      }),
      turbo_stream.replace('log-all-reps', partial: 'challenges/log_all_button', locals: { reps_remaining: @preps_remaining })
    ]
  end
end