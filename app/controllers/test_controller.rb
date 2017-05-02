class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
	  	@output = Contact.all.where(code:'clock')
	  	Contact.all.where(code:'running').destroy
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end