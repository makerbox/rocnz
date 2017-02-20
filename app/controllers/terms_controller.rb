class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    Product.all.each do |p|
      @results << p.category
    end
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @xray = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    dbh.disconnect
    # system "heroku db:push"
  end #end def index

end #end class
