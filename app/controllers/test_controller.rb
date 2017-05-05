class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@output = []
	  	counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        counter += 1
        if ce.InactiveCust == (1 || 'Yes')
          code = ce.Code.strip
          account = Account.all.find_by(code: code)
          user = account.user
          @output << user.email
          @output << account.email
          account.destroy
          user.destroy
        else
          code = ce.Code.strip
          email = ce.EmailAddr
          if !Account.all.find_by(code: code)
            if email.blank?
              email = counter
            end
            if !User.all.find_by(email: email)
              # newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
              # if newuser.save(validate: false) #false to skip validation
              #   newuser.add_role :user
              #   newaccount = Account.new(code: code, user: newuser) #create the account and associate with user
              #   newaccount.save
              # end
            end
          end
        end
      end





	  	# Contact.all.find_by(code:'running').destroy
	  	# Contact.all.find_by(code:'clock').destroy
	  	@output = Contact.all.where(code:'clock')

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end