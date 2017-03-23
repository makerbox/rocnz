class TermsController < ApplicationController
	skip_before_action :authenticate_user!
	def index
		@results = []
		Account.destroy_all
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		@customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
		@customers_ext.each do |ce|
			if ce.InactiveCust == 0
				code = ce.Code.strip
				@results << code
				@results << ce.CostCentre
				@results << ce.CountryCode
					# Account.create(code: code)
				end
			end
		end
		@customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
		@customers.each do |c|
			if account = Account.all.find_by(code: c.Code.strip)
				compname = c.Name
				street = c.Street
				suburb = c.Suburb 
				postcode = c.Postcode 
				phone = c.Phone 
				sort = c.Sort 
				discount = c.SpecialPriceCat 
				seller_level = c.PriceCat
				rep = c.SalesRep
				account.update_attributes(company: compname)
			end
		    # code
		    # name
		    # street
		    # suburb
		    # postcode
		    # phone
		    # Contact
		    # sort
		    # territory
		    # SalesRep
		    # cat
		    # PriceCat
		    # specialpricecat
		    # (camelcase)

		    # Account.create(rep: rep)
		end
		dbh.disconnect
  	end #end def index

end #end class
