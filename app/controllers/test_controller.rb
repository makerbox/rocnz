class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index

		dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
		@products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
		dbh.disconnect
	end

end