class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def new_order(order)
		mail(to: 'mattwerth@mattwerth.com', subject: 'Your order summary from RocCloudy')
		@order = order
		account = @order.user.account
  
  
		  @print = "YOUR ORDER FROM ROC CLOUDY WHOLESALE PORTAL ["+ Time.now.strftime("%d/%m/%Y || %r") +"] \r\n"
		  @print += "------------------ WEB" + @order.id.to_s + " ----------------------- \r\n"

		  @print += "------------------------------------------------------------------- \r\n"
		  @print += account.street.to_s + ' | ' + account.suburb.to_s + ' | ' + account.phone.to_s + "\r\n"
		  @print += "------------------------------------------------------------------- \r\n\n"
		  @order.quantities.each do |q|
		    
		    @print += "~" + q.products.first.code.to_s + "\r\n[" + q.products.first.description.strip + ' x ' + q.qty.to_s + "\r\n\n"
		  end
		  @print += "-------------------------------------------------------------------\r\n"
		  @print += "total: $" + @order.total.to_s + "\r\n"
		  @print += "-------------------------------------------------------------------"
	end
end
