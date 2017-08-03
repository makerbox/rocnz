class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index

    @results = []

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
      @customers.each do |c|
          @results << c.CustomerType
          @results << '<------>'
          @results << c.Customer
          @results << '------||'
      end
      dbh.disconnect 


end
end