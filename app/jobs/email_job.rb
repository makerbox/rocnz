# app/jobs/email_job.rb
class EmailJob
	include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(contacts)
  	AdminMailer.new_user_waiting_for_approval(contacts).deliver_now
  end

end