# app/jobs/email_job.rb
class UserEmailJob
	include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(contacts)
  	UserMailer.welcome_email(contacts).deliver_now
  end

end