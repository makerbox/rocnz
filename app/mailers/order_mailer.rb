class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		@account = order.user.account
		subject = 'Roc Cloudy order ' + order.user.account.code.strip
		mail(to: 'wholesaleorder@roccloudy.com', subject: subject)
	end
	def receipt(order)
		@thisorder = order
		@account = order.user.account
		mail(to: 'mattwerth@mattwerth.com', subject: 'Roc Cloudy order')
	end
	def rep(order)
		@thisorder = order
		@account = order.user.account
		mail(to: current_user.email, subject: 'Roc Cloudy order')
	end
end
