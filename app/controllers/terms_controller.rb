class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
	@results = Discount.all.discount
  end #end def index

end #end class
