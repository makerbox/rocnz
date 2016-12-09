class OrderMailer < ApplicationMailer
		default from:'web@roccloudy.com'
	
	def new_order(order)
		mail(to: 'mattwerth@mattwerth.com', subject: 'Your order summary from RocCloudy')
		@order = order
		account = @order.user.account
  
  if account.company # start putting together printable order
    company = account.company
  else
    company = 'no company ' + account.phone #if no company name, then show phone number instead
  end
  @print = "NEW ORDER FROM ROC CLOUDY WHOLESALE PORTAL ["+ Time.now.strftime("%d/%m/%Y || %r") +"] \r\n"
  @print += "------------------------------------------------------------------- \r\n"
  @print += "------------------------------------------------------------------- \r\n"
  @print += "------------------ WEB" + @order.id.to_s + " ----------------------- \r\n"
  @print += "------------------------------------------------------------------- \r\n"
  @print += "------------------------------------------------------------------- \r\n"
  if current_user.has_role? :admin
    @print += "------------made by SALES REP-------- \r\n"
  end
  @print += "THIS IS A TEST (please diregard) - order from " + company + "\r\n"
  @print += "------------------------------------------------------------------- \r\n"
  @print += account.street.to_s + ' | ' + account.suburb.to_s + ' | ' + account.phone.to_s + "\r\n"
  @print += "------------------------------------------------------------------- \r\n\n"
  @order.quantities.each do |q|
    product = Product.find_by(id: q.product_id)
    if (current_user.has_role? :admin) && (!current_user.mimic.nil?) 
    level = current_user.mimic.account.seller_level.to_i 
    else 
    level = current_user.account.seller_level.to_i 
    end 
    case level
      when 1
        @setprice = product.price1 / 100 * product.discount(current_user)
      when 2
        @setprice = product.price2 / 100 * product.discount(current_user)
      when 3
        @setprice = product.price3 / 100 * product.discount(current_user)
      when 4
        @setprice = product.price4 / 100 * product.discount(current_user)
      when 5
        @setprice = product.price5 / 100 * product.discount(current_user)
      when 6
        @setprice = product.rrp / 100 * product.discount(current_user)
    end
    @setprice = @setprice.round(2)
    @print += "~" + product.code.to_s + "\r\n[" + product.description.strip + "]\r\n$" + @setprice.to_s + " x qty:" + q.qty.to_s + "\r\n\n"
  end
  @print += "-------------------------------------------------------------------\r\n"
  @print += "total: $" + @order.total.to_s + "\r\n"
  @print += "-------------------------------------------------------------------"
	end
end
