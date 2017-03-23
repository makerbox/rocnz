class TermsController < ApplicationController
	skip_before_action :authenticate_user!
	def index
		UserMailer.welcome_email('mattwerth@mattwerth.com').deliver_now
		@results = []
		# Account.destroy_all
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		@customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
		@customers_ext.each do |ce|
			if ce.InactiveCust == 0
				code = ce.Code.strip
				if !Account.all.find_by(code: code)
					@results << code
					Account.create(code: code)
				else
					@results << code + ' exists!'
				end
			end
		end
		@customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
		@customers.each do |c|
			if Account.all.find_by(code: c.Code.strip)
				account = Account.all.find_by(code: c.Code.strip)
				compname = c.Name
				street = c.Street
				suburb = c.Suburb 
				postcode = c.Postcode 
				phone = c.Phone 
				sort = c.Sort 
				discount = c.SpecialPriceCat 
				seller_level = c.PriceCat
				rep = c.SalesRep
				@results << c.SalesRep
				@results << 'updated for ' + c.Code.strip
				account.update_attributes(company: compname, rep: rep, seller_level: seller_level, discount: discount)
			else
				@results << 'no account, no rep'
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
