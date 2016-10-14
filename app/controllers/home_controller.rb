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
    Discount.each do |d|
      customer = d.customer.strip
      product = d.product.strip
      d.update (product: product, customer: customer)
    end    
  end

end #end of class
