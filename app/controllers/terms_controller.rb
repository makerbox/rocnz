class TermsController < ApplicationController
	skip_before_action :authenticate_user!
	def index
		UserMailer.welcome_email('mattwerth@mattwerth.com').deliver_now
		@results = []
		# Account.destroy_all
		
  	end #end def index

end #end class
