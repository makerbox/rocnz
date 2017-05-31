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

      # --------------------- ADD EMAIL ADDRESSES ----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      contacts.each do |contact|
        if contact.Active == 1
          if account = Account.all.find_by(code: contact.Code.strip)
            if !User.all.find_by(email: contact.EmailAddress)
            	@results = account.user.email
              # account.user.update_attributes(email: contact.EmailAddress)
            end
          end
        end
      end
      dbh.disconnect 

		# OrderMailer.receipt(Order.all.last, current_user).deliver_now
		# @result = `heroku db:push [postgres://bpupvrcqomwfwk:55tz1h8GUNGOyWVTkWFjAttzY7@ec2-54-225-244-221.compute-1.amazonaws.com:5432/de53vgd0mccdbt]`
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end