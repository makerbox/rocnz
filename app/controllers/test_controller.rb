class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@results = []
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
          @discounts = Discount.all
		
          dbh.disconnect
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	  end
	end