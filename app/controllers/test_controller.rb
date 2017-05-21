class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		OrderEmailJob.perform_async(Order.all.last)
		@result = `heroku pg:credentials`
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end