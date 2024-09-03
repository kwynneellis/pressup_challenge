class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_challenge

  def create
    date = params[:log][:date_of_set] || Date.today
    @log = @challenge.logs.new(log_params)

    if @log.save
      redirect_to day_press_ups_path(date_of_set: date), notice: 'Press-ups logged successfully!'
    else
      redirect_to day_press_ups_path(date_of_set: date), alert: 'Failed to log press-ups.'
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
      redirect_to day_press_ups_path(date_of_set: date), notice: "#{date}'s logs have been reset."
    else
      redirect_to day_press_ups_path(date_of_set: date), alert: "No logs to reset for #{date}."
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

  private

  def set_challenge
    @challenge = current_user.challenges.find(params[:challenge_id])
  end

  def log_params
    params.require(:log).permit(:reps_in_set, :date_of_set)
  end
end