class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []	
	Product.all.each do |newd|
		@results << newd.new_date
		@results << newd.code
		@results << '......................'
	end
	@results << Discount.all.count
  end #end def index

end #end class
