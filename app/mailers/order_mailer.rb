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
    product = Product.find_by(id: q.product_id)
    if (@order.user.has_role? :admin) && (@order.user.mimic.nil?) 
    level = @order.user.mimic.account.seller_level.to_i 
    else 
    level = @order.user.account.seller_level.to_i 
    end 
    case level
      when 1
        @setprice = product.price1 / 100 * product.discount(@order.user)
      when 2
        @setprice = product.price2 / 100 * product.discount(@order.user)
      when 3
        @setprice = product.price3 / 100 * product.discount(@order.user)
      when 4
        @setprice = product.price4 / 100 * product.discount(@order.user)
      when 5
        @setprice = product.price5 / 100 * product.discount(@order.user)
      when 6
        @setprice = product.rrp / 100 * product.discount(@order.user)
    end
    @setprice = @setprice.round(2)
    @print += "~" + product.code.to_s + "\r\n[" + product.description.strip + "]\r\n$" + @setprice.to_s + " x qty:" + q.qty.to_s + "\r\n\n"
  end
  @print += "-------------------------------------------------------------------\r\n"
  @print += "total: $" + @order.total.to_s + "\r\n"
  @print += "-------------------------------------------------------------------"
	end
end
