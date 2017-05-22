# app/jobs/order_email_job.rb
class OrderEmailJob
	include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(order)
  	  OrderMailer.order(order).deliver_now
  	  OrderMailer.receipt(order).deliver_now
  end

end