class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
  qty = 4
  prod_group = 'D'
  prod_code = '1829DM'
  # price_cat = params[:pricecat]

  if current_user.mimic
    u = current_user.mimic.account.user
  else
    u = current_user
  end
  
  if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip)) #get the matching discounts
    disco = discos.where('maxqty > ?', qty)
    @result = disco.discount
  else
  	@result = 'none'
  end
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end