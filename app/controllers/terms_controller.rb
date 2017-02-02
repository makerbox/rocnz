class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    @categories.each do |cat|
      if cat.CostCentre
      @results << cat.CostCentre
    end
      # @results << Product.find_by(code: cat.Code).code
    end
    dbh.disconnect
  end #end def index

end #end class
