class TermsController < ApplicationController
		skip_before_action :authenticate_user!
  def index

  	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
  	discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    @dates
	products.each do |p|
		dbhstring = "SELECT * FROM produdefdata WHERE Code='#{p.Code}' " #p.Code.strip
        saledate = dbh.execute(dbhstring).fetch(:all, :Struct)
        # if saledate
        #   saledate = saledate.DateFld
        # else
        #   saledate = Date.today - 35.days
        # end
        @dates << saledate
    end


  end

end
