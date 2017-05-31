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

      def createrep(repemail, repcode)
        if repuser = User.all.find_by(email: repemail)
          repuser.add_role :admin
          repuser.remove_role :user
          if repuser.account
            repuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
          else
            Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
          end
        else
          repuser = User.new(email: repemail, password:'cloudy_16', password_confirmation: 'cloudy_16')
          repuser.add_role :admin
          repuser.save(validate: false)
          Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
        end
        @results << repuser.email
      end

      createrep('nsw@roccloudy.com', 'REPNSW')
      createrep('vic@roccloudy.com', 'REPVIC')
      createrep('qld1@roccloudy.com', 'REPQLD1')
      createrep('qld2@roccloudy.com', 'REPQLD2')
      createrep('nz@roccloudy.com', 'REPNZ')
      createrep('office@roccloudy.com', 'ADMINOFFICE')
		# OrderMailer.receipt(Order.all.last, current_user).deliver_now
		# @result = `heroku db:push [postgres://bpupvrcqomwfwk:55tz1h8GUNGOyWVTkWFjAttzY7@ec2-54-225-244-221.compute-1.amazonaws.com:5432/de53vgd0mccdbt]`
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end