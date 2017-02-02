class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    @products.each do |p|
      category = @categories.where(code: p.Code).CostCentre.to_i.strip
      Product.where(code: p.Code).first.update_attributes(category: category)
    end
    dbh.disconnect
  end #end def index

end #end class
