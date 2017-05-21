class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@results = []
		
		qty = 4
  price = 4.8
  prod_group = 'D'
  prod_code = '1829DM'
  # price_cat = params[:pricecat]

  if current_user.mimic
    u = current_user.mimic.account.user
  else
    u = current_user
  end
  
  if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip)) #get the matching discounts
    discos.each do |disco| #loop through to find which maxqty applies
      # @result = number_with_precision(disco.discount, precision: 2)
      @result = disco.discount
      @tester = disco.discou
      # if qty <= disco.maxqty
      #   @thedisco = disco #set @thedisco to the discount in which this qty fits
      # else
      #   @thedisco = nil #otherwise jsut be nil if it doesn't fit or is above the top max qty
      # end
    end
  else

    # if @thedisco
    #   result = price - @thedisco.discount
    #   # need to also work for percentage discount
    # else
    #   result = price #should be discounted price
    # end
    @result = price
  end
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	  end
	end