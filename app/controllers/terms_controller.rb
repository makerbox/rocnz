class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
	@results = Discount.all
	@products = Product.all
  end #end def index

end #end class
