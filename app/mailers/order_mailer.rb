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
		if (current_user.has_role? :admin) && (!current_user.mimic.nil?)
            @level = current_user.mimic.account.seller_level.to_i
			@thisperson = current_user.mimic.account.user
		else
			@level = current_user.account.seller_level.to_i
			@thisperson = current_user
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
