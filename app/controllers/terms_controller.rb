class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    @categories.each do |cat|
      if cat.CostCentre
        categorycode = cat.Code.strip
        @results << cat.Code
        @results << Product.where(code: categorycode).code
      end
    end
    dbh.disconnect
  end #end def index

end #end class
