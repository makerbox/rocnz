class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@results = []
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
          @discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
		
          dbh.disconnect
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	  end
	end