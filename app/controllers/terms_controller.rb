class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    
    @products.first do |p|
      category = dbh.execute("SELECT CostCentre FROM prodmastext WHERE Code LIKE '#{p.Code}%' ").fetch(:all, :Struct)[0].to_h[:CostCentre]
      # Product.where(code: p.Code).update_attributes(category: category)
      @results << category
    end
    dbh.disconnect
  end #end def index

end #end class
