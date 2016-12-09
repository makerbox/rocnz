class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def order(order)
		@thisorder = order
		mail(to: 'mattwerth@mattwerth.com', subject: @thisorder.id)
	end
end
