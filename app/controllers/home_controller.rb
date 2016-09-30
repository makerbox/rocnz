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
    @test = dbh.execute("SELECT * FROM productgroup_name").fetch(:all, :Struct)
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @productgroups = []
    @products.each do |p|
      @productgroups << p.Group
    end
    @productgroups = @productgroups.uniq
  end

end
