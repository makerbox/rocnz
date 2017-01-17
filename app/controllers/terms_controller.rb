class TermsController < ApplicationController
		skip_before_action :authenticate_user!
  def index
  		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
  		products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
  		productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
  	    alldates = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)
  	    products.each do |p|
	        if alldates.where(Code: p.Code)
	          saledate = alldates.where(Code: p.Code)
	        else
	          saledate = Date.today - 40.days
	        end

	        product = Product.where(code: p.Code.to_s.strip).first

	        category = dbh.execute("SELECT CostCentre FROM prodmastext WHERE Code = '#{p.Code}' ").fetch(:all, :Struct)[0].to_h[:CostCentre]
	        if category != nil
	          category = category.strip
	        end
	    end
  end

end
