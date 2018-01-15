class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
@results = []
		dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.Code.strip
        if Account.all.find_by(code: code)
          account = Account.all.find_by(code: code)
          compname = c.Name
          street = c.Street
          suburb = c.Suburb 
          state = c.Territory
          postcode = c.Postcode 
          phone = c.Phone 
          sort = c.Sort 
          discount = c.SpecialPriceCat 
          seller_level = c.PriceCat
          rep = c.SalesRep
          account.update_attributes(approved: 'approved', phone: phone, street: street, state: state, suburb: suburb, postcode: postcode, sort: sort, company: compname, rep: rep, seller_level: seller_level, discount: discount)
        @results << sort << '-----' << compname
        end
      end
      dbh.disconnect 
	end

end