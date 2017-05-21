class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	# def order(order, user)
	# 	@thisorder = order
	# 	@account = order.user.account
	# 	@user = user
	# 	subject = 'Roc Cloudy order ' + order.user.account.code.strip
	# 	mail(to: 'wholesaleorder@roccloudy.com', subject: subject)
	# end
	def receipt(order, user)
		@thisorder = order
		@account = order.user.account
		@user = user
		mail(to: 'mattwerth@mattwerth.com', subject: 'Roc Cloudy order')
	end
	# def rep(order, user)
	# 	@thisorder = order
	# 	@account = order.user.account
	# 	@user = user
	# 	mail(to: current_user.email, subject: 'Roc Cloudy order')
	# end
end
