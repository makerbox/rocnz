class TermsController < ApplicationController
		skip_before_action :authenticate_user!
  def index
  	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    # customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
    # activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    # contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
	products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    products.each do |p|
    	@productscreen += p.Code
    end
  dbh.disconnect

  end

end
