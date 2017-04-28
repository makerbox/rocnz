class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
	  	# system "clockwork clock.rb"
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	 	@sort = User.checksort(current_user)
	end
end