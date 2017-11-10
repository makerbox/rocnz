class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index

		dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
		@products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)

@results = []
@products.each do |p|
	@results << p.Code
	@results << '= inactive?'
	@results << p.inactive
	@results << '............'
	end


		dbh.disconnect
	end

end