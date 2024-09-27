class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:create, :index, :reset_logs, :catch_up]

  def create
    date = params[:date_of_set] || Date.today
    reps = params[:reps_in_set]
    @log = @challenge.logs.new(date_of_set: date, reps_in_set: reps)

    @log.user = current_user

    if @log.save
      redirect_to day_challenge_path(@challenge, date: date), notice: 'Log was successful!'
    else
      redirect_to day_challenge_path(@challenge, date: date), alert: 'Failed to log.'
    end
  end

  def index
    @logs = @challenge.logs.order(created_at: :desc)
  end

  def reset_logs
    date = params[:date_of_set] || Date.today
    day_logs = @challenge.logs.where(date_of_set: date, user: current_user)

    if day_logs.exists?
      day_logs.destroy_all
      redirect_to day_challenge_path(@challenge, date: date), notice: "#{date}'s logs have been reset."
    else
      redirect_to day_challenge_path(@challenge, date: date), alert: "No logs to reset for #{date}."
    end
  end

  def index_all
    logs = Log.joins(challenge: :participations)
            .joins(:user)
            .where(users: { visibility: true })
            .where.not(reps_in_set: nil)
            .distinct # Ensure unique logs
            .includes(:challenge, :user)
            .order(date_of_set: :desc, created_at: :desc)

    # Group logs by date, user and challenge
    @logs_by_date_user_and_challenge = logs.group_by { |log| [log.date_of_set, log.user, log.challenge] }
  end

  def catch_up
    user = current_user

    @challenge.start_date.upto(Date.today) do |date|
      target_reps = @challenge.rep_target_for(date)
      existing_reps = Log.where(challenge: @challenge, user: user, date_of_set: date).sum(:reps_in_set)

      if existing_reps < target_reps
        # Create a log with the remaining target reps for that day
        Log.create(
          challenge: @challenge,
          user: user,
          date_of_set: date,
          reps_in_set: target_reps - existing_reps
        )
      end
    end

    redirect_to challenge_path(@challenge), notice: "Logs caught up!"
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
    unless @challenge
      redirect_to challenges_path, alert: "Challenge not found."
    end
  end

  def log_params
    params.require(:log).permit(:date_of_set, :reps_in_set)
  end
end