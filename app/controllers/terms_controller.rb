class TermsController < ApplicationController
		skip_before_action :authenticate_user!
  def index
  	@reply = 'starting discount list...'
  	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    # customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
    # activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    # contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
	discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    discounts.each do |p|
    	@reply = @reply + p + '<br>'
    end
  dbh.disconnect

  end

end
