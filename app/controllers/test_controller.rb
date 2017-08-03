class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index

    @results = []

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
          @results << c.PriceCat
          @results << '-cat-----'
          @results << c.Name
          @results << '-name-----'
          @results << c.SpecialPriceCat
      end
      dbh.disconnect 


end
end