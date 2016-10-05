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
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @transactions = dbh.execute("SELECT * FROM customer_transactions").fetch(:all, :Struct)

strip inactive, pictureless, etc odbc items
    for each odbc item
      see if it exists
        see if it needs updating
   # @test = Product.all
   # @test.each do |p|
   #    if p.category != nil
   #      cat = p.category.strip
   #      p.update(category: cat)
   #    end
   #  end
  end

end
