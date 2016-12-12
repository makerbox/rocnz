class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		mail(to: 'george@roccloudy.com', subject: 'new order from Roc Cloudy')
	end
end
