class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def new_order(order)
		mail(to: 'mattwerth@mattwerth.com', subject: 'Your order summary from RocCloudy')
		@thisorder = '33'
  
	end
end
