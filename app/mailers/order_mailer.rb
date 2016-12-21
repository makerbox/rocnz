class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		@account = order.user.account
		@email = order.user.email
		if current_user.has_role? :admin
			mail(to: current_user.email, subject: 'new Roc Cloudy order')
		end
		mail(to: 'mattwerth@mattwerth.com', subject: 'new order from Roc Cloudy')
		mail(to: @email, subject: 'your order from Roc Cloudy')
	end
end
