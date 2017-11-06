class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		results = []
		dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
		@products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
        @products.each do |p|
        	results << p.Inactive
        	results << p.Code
        	results << '-----------'
        end
	end

end