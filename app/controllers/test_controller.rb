class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@output = []
	  	counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @products = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
		
		prod_group = 'R'
		prod_code = '3009100B'
		price_cat = ''
		if current_user.mimic
			u = current_user.mimic.account.user
		else
			u = current_user
		end
		@discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip))





	  	# Contact.all.find_by(code:'running').destroy
	  	# Contact.all.find_by(code:'clock').destroy
	  	# @output = Contact.all.where(code:'clock')

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end