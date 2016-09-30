class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def pull
      system "git pull"
      redirect_to :back
  end

  def seed
    system "rake db:seed"
    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
    require 'rdbi-driver-odbc'
    puts "connecting to database"
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @genledger = dbh.execute("SELECT * FROM genledger_sets").fetch(:all, :Struct)
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @uniqproducts = []
    @uniqgenledger = []
    @products.each do |p|
      @uniqproducts << p.GlSet 
    end
    @genledger.each do |g|
      @uniqgenledger << g.Code
      @uniqgenledger << g.Name
    end
    @uniqproducts = @uniqproducts.uniq
    @uniqgenledger = @uniqgenledger.uniq
  end

end
