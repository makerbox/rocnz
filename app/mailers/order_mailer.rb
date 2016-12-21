class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		@account = order.user.account
		@email = [order.user.account.contact.email, 'mattwerth@mattwerth.com']
		if current_user.has_role? :admin
			@email << current_user.email
		end
		mail(to: @email, subject: 'Roc Cloudy order')
	end
end
