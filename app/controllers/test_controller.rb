class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		Contact.destroy_all
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end