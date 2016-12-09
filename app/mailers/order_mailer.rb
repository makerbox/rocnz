class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def new_order(order)
		realemail = order.account.user.email
		mail(to: 'mattwerth@mattwerth.com', subject: 'Your order summary | RocCloudy')
	end
end
