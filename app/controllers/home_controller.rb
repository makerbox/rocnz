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
    redirect_to 'home#index'
  end

  def seed
    system "rake db:seed"
    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
    system "rake jobs:work"
    system "clockwork lib/clock.rb"
    redirect_to 'home#index'
  end

end #end of class
