class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		@account = order.user.account
		# mail(to: order.user.email, subject: 'your order from Roc Cloudy')
		mail(to: 'mattwerth@mattwerth.com; maker-box@hotmail.com', subject: 'your order from Roc Cloudy')
	end
end
