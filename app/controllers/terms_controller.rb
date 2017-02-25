class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    


    dbh.disconnect   
  end #end def index

end #end class
