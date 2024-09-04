class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:show, :show_by_date, :edit, :update, :destroy]

  def index
    @challenges = current_user.challenges
  end

  def show
    @date = Date.today
    load_log_data_for(@date)
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