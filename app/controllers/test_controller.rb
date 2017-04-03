class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
  	@result = dbh.tables
 #    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
 #    @products.each do |p|
 #      if p.Inactive == 0
 #        code = p.Code.strip
 #        description = p.Description.to_s.strip
 #        price1 = p.SalesPrice1
 #        price2 = p.SalesPrice2
 #        price3 = p.SalesPrice3
 #        price4 = p.SalesPrice4
 #        price5 = p.SalesPrice5
 #        rrp = p.SalesPrice6
 #        qty = p.QtyInStock
 #        @result << code + ' - ' + price1.to_s
	#   end
	# end

  end
end
