class UserMailer < ApplicationMailer
  def daily_target_reminder
    @user = params[:user]
    @outstanding_challenges = @user.joined_challenges.with_unmet_targets_for(@user)

    return if @outstanding_challenges.empty?

    mail(to: @user.email, subject: 'Reminder: Your Daily Target')
  end
end
