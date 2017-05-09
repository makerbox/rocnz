class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@output = []
	  	counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        	code = c.Code.strip
          compname = c.Name
          street = c.Street
          suburb = c.Suburb 
          postcode = c.Postcode 
          phone = c.Phone 
          sort = c.Sort 
          discount = c.SpecialPriceCat 
          seller_level = c.PriceCat
          rep = c.SalesRep

      end


	  	# Contact.all.find_by(code:'running').destroy
	  	# Contact.all.find_by(code:'clock').destroy
	  	# @output = Contact.all.where(code:'clock')

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end