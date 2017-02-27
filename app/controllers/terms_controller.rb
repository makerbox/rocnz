class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
	@results = Discount.where(customer: (current_user.mimic.user.account.discount || current_user.mimic.user.account.code.strip))

  end #end def index

end #end class
