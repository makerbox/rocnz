class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		# @goodcount = 0
		# @badcount = 0
		# @results = []
		# @users = User.all
		# @users.each do |u|
		# 	if u.email.include? '@'
		# 		@goodcount = @goodcount + 1
		# 	else
		# 		@badcount = @badcount + 1
		# 		@results << u.account
		# 	end
		# end
		@results = []

		@result = `postgres --version`


		# WORKING!!!!!!!!!!!!!!!!!!
		# run this in separate function first! -> `heroku pg:reset postgresql-crystalline-39951 --app young-island-86511 --confirm young-island-86511`
		# @result = `heroku pg:push main postgresql-crystalline-39951 --app young-island-86511`
      




      # Order.destroy_all
      # Quantity.destroy_all

		# OrderMailer.receipt(Order.all.last, current_user).deliver_now
		# @result = `heroku db:push [postgres://bpupvrcqomwfwk:55tz1h8GUNGOyWVTkWFjAttzY7@ec2-54-225-244-221.compute-1.amazonaws.com:5432/de53vgd0mccdbt]`
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end