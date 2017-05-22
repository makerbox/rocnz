# app/jobs/order_email_job.rb
class OrderEmailJob
	include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(order, user)
  	  # OrderMailer.order(order, user).deliver_now
  	  OrderMailer.receipt(order, user).deliver_now
  	  # if current_user.has_role? :admin
  	  # 	OrderMailer.rep(order, user).deliver_now
  	  # end
  end

end