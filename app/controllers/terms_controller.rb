class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = Discount.all
    # system "heroku db:push"
  end #end def index

end #end class
