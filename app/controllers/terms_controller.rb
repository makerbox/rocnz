class TermsController < ApplicationController
		skip_before_action :authenticate_user!
  def index
  		@results = []
  		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
  		@products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
  		productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
  	    @alldates = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)[0].to_h
  	    @results = @alldates.first
  	  	@products.each do |p|
  	  		# @alldates.each do |d|
  	  			# if d.Code = p.Code
  	  				# saledate = d.Code
  	  				# @results << saledate
  	  				# @results << p.Code
  	  			# end
  	  		# end

	    #     # product = Product.where(code: p.Code.to_s.strip).first

	    #     category = dbh.execute("SELECT CostCentre FROM prodmastext WHERE Code = '#{p.Code}' ").fetch(:all, :Struct)[0].to_h[:CostCentre]
	    #     if category != nil
	    #       category = category.strip
	    #     end
	    #     @categories << category
	    end
  end

end
