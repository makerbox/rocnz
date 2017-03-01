class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
	discounts = Discount.all
	products = Product.all
	products.each do |p|
		@results << discounts.where(product: p.code).first
	end
  end #end def index

end #end class
