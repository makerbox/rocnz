class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
  qty = 4
  prod_group = 'D'
  prod_code = '1829DM'
  # price_cat = params[:pricecat]
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end