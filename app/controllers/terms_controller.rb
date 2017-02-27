class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
	@results = Discount.where(customer: (current_user.mimic.account.discount || current_user.mimic.account.code.strip))

  end #end def index

end #end class
