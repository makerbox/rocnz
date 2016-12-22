class TermsController < ApplicationController
		skip_before_action :authenticate_user!
  def index
  	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

    # customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
    # activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    # contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)
    @productscreen = []
    products.each do |p|
    	if p.Inactive == 0
        	dbhstring = "SELECT * FROM produdefdata WHERE Code='#{p.Code}' "
        	@saledate = dbh.execute(dbhstring).fetch(:all, :Struct)
    
        	# if @saledate
         #  		@saledate = @saledate.DateFld
        	# else
         #  		@saledate = nil
        	# end
        	@productscreen << @saledate
        	@product = Product.find_by(code: p.Code)
        	@productscreen << @product.code
    	end
	end

  end

end
