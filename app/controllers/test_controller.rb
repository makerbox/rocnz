class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
      @categories.each do |cat|
            if cat.CostCentre #if the prodmastext record has a category, then let's do it
              categorycode = cat.Code.strip
              if Product.find_by(code: categorycode) #if the product exists, let's give it the category (some products without images have no dice)
                # Product.find_by(code: categorycode).update_attributes(category: cat.CostCentre.strip)
              	@results << "category code - "
              	@results << categorycode
              	@results << " + cost centre - "
              	@results << cat.CostCentre
              	@results << "------------------------"
              end
            end
          end
          dbh.disconnect
  end
end