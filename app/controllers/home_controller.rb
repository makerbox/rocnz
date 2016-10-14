class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def pull
      system "git pull"
      # system "bundle"
      # system "rails restart -b 0.0.0.0"
      # system "rake jobs:work"
      # system "rake db:seed"
  end

  def seed
    system "rake db:seed"
    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
    # Discount.all.each do |d|
    #   newcustomer = d.customer.strip
    #   newproduct = d.product.strip
    #   d.update(product: newproduct, customer: newcustomer)
    # end
  end

end #end of class
