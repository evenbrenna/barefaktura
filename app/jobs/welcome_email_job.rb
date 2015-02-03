#app/jobs/welcome_email_job.rb

class WelcomeEmailJob < ActiveJob::Base
  queue_as :email

  def perform(user)
    UserMailer.welcome_email(user).deliver_now
  end
end