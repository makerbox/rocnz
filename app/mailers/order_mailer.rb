class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	# def order(order, user)
	# 	@thisorder = order
	# 	@account = order.user.account
	# 	@user = user
	# 	subject = 'Roc Cloudy order ' + order.user.account.code.strip
	# 	mail(to: 'wholesaleorder@roccloudy.com', subject: subject)
	# end
	def receipt(order)
		@thisorder = order
		@account = order.user.account
		user = order.user
		if (user.has_role? :admin) && (!user.mimic.nil?)
            @level = user.mimic.account.seller_level.to_i
			@thisperson = user.mimic.account.user
		else
			@level = user.account.seller_level.to_i
			@thisperson = user
		end
		mail(to: 'mattwerth@mattwerth.com', subject: 'Roc Cloudy order')
	end
	# def rep(order, user)
	# 	@thisorder = order
	# 	@account = order.user.account
	# 	@user = user
	# 	mail(to: current_user.email, subject: 'Roc Cloudy order')
	# end
end
