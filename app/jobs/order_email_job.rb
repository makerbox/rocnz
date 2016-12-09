# app/jobs/order_email_job.rb
class OrderEmailJob
	include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(order)
  	# ditched suckerpunch on thsi for now - will reinstate later
  end

end