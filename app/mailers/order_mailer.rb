class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		@account = order.user.account
		mail(to: 'office@roccloudy.com', subject: 'Roc Cloudy order')
	end
	def receipt(order)
		@thisorder = order
		@account = order.user.account
		mail(to: @account.contact.email, subject: 'Roc Cloudy order')
	end
	def rep(order)
		@thisorder = order
		@account = order.user.account
		mail(to: current_user.email, subject: 'Roc Cloudy order')
	end
end
