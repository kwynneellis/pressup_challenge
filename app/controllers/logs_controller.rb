class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge, only: [:create, :index, :reset_logs, :update_all_logs]

  def create
    date = params[:log][:date_of_set] || Date.today
    @log = @challenge.logs.new(log_params)
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
    day_logs = @challenge.logs.where(date_of_set: date)

    if day_logs.exists?
      day_logs.destroy_all
      redirect_to day_challenge_path(@challenge, date: date), notice: "#{date}'s logs have been reset."
    else
      redirect_to day_challenge_path(@challenge, date: date), alert: "No logs to reset for #{date}."
    end
  end

  def update_all_logs
    # WIP - update this to be on the challenge show page, not user show page. 
    ActiveRecord::Base.transaction do
      @challenge.logs.destroy_all # Delete all existing logs

      @challenge.start_date.upto(Date.today) do |date|
        rep_target = @challenge.rep_target_for(date)
        @challenge.logs.create!(date_of_set: date, reps_in_set: rep_target)
      end
    end

    redirect_to challenge_path(@challenge), notice: "Your logs have been updated to be up-to-date."
  rescue => e
    redirect_to challenge_path(@challenge), alert: "There was an error updating your logs: #{e.message}"
  end

  def index_all
    # Fetch logs and join participations
    logs = Log.joins(challenge: :participations)
              .where("challenges.public = ? OR participations.user_id = ?", true, current_user.id)
              .includes(:challenge, :user)
              .order(created_at: :desc)

    # Group logs by date, user and challenge
    @logs_by_date_user_and_challenge = logs.group_by { |log| [log.date_of_set, log.user, log.challenge] }
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
    unless @challenge
      redirect_to challenges_path, alert: "Challenge not found."
    end
  end

  def log_params
    params.require(:log).permit(:date_of_set, :reps_in_set, :completed_the_day)
  end
end