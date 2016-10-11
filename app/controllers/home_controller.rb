class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def pull
      system "git pull"
      # system "bundle"
      # system "rake db:migrate"
      # system "rails restart -b 0.0.0.0"
      # system "rake jobs:work"
  end

  def seed
    system "rake db:seed"
    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
    # system "rake jobs:work"
    # system "clockwork lib/clock.rb"
    # redirect_to 'home#index'

        # GET THE DATA INTO VARIABLES--------------------------------------------------------------------------
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal" # connect to DB

  specialprices = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
  @count = specialprices.count
  @test = []
    specialprices.each do |s|
      s.to_h
      if s.Customer == current_user.account.code
        @test << s
      end
    end

  end

end #end of class
