class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def pull
      system "git pull"
      system "bundle"
      # system "rake db:migrate"
      # system "rails restart -b 0.0.0.0"
      # system "rake jobs:work"
      redirect_to :back
  end

  def seed
    system "rake db:seed"
    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff

    every(20.minutes, 'populate') { 
      Product.delay.populate
       }

  end

end #end of class
