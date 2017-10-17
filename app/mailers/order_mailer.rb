class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
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
		subject = 'Roc Cloudy order ' + order.user.account.code.strip
		mail(to: 'invoice@roccloudy.com', subject: subject)
	end
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
		mail(to: user.email, subject: 'Roc Cloudy order')
	end
end
