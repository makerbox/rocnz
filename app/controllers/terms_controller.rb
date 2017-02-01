class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

    Product.all.each do |p|
      category = dbh.execute("SELECT CostCentre FROM prodmastext WHERE Code = '#{p.Code}' ").fetch(:all, :Struct)[0].to_h[:CostCentre]
      @results << category
    end
    dbh.disconnect
  end #end def index

end #end class
