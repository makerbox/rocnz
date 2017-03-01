class TermsController < ApplicationController
	skip_before_action :authenticate_user!
	def index

@results = []	
Discount.all.each do |disc|
	@results << disc.type
	@results << '......................'
end
@results << Discount.all.count
  end #end def index

end #end class
