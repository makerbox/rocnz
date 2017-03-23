class TermsController < ApplicationController
	skip_before_action :authenticate_user!
	def index
		@results = []
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		@customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
		@customers_ext.each do |ce|
			@results << ce.InactiveCust
		end

  # @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
  # @customers.each do |c|
  #   code = c.Code
  #   compname = c.Name
  #   street = c.Street
  #   suburb = c.Suburb 
  #   postcode = c.Postcode 
  #   phone = c.Phone 
  #   sort = c.Sort 
  #   discount = c.SpecialPriceCat 
  #   seller_level = c.PriceCat
  #   rep = c.SalesRep
  #   # code
  #   # name
  #   # street
  #   # suburb
  #   # postcode
  #   # phone
  #   # Contact
  #   # sort
  #   # territory
  #   # SalesRep
  #   # cat
  #   # PriceCat
  #   # specialpricecat
  #   # (camelcase)

  #   # Account.create(rep: rep)
  # end
dbh.disconnect
  	end #end def index

end #end class
