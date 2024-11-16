# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def daily_target_reminder
    user = User.first
    UserMailer.with(user: user).daily_target_reminder
  end
end
