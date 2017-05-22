class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@goodcount = 0
		@badcount = 0
		@results = []
		@orders = User.all
		@orders.each do |o|
			if o.email.include? '@'
				@goodcount = goodcount + 1
			else
				@badcount = badcount + 1
				@result << o.account.company
			end
		end
		# OrderMailer.receipt(Order.all.last, current_user).deliver_now
		# @result = `heroku db:push [postgres://bpupvrcqomwfwk:55tz1h8GUNGOyWVTkWFjAttzY7@ec2-54-225-244-221.compute-1.amazonaws.com:5432/de53vgd0mccdbt]`
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end