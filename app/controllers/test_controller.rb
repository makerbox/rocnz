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

     # -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

      counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        counter += 1
        code = ce.Code.strip
        if ce.InactiveCust == 1
          if Account.all.find_by(code: code)
            account = Account.all.find_by(code: code) # if there is an attache inactive account already in the portal, we delete it and its user
            user = account.user
            account.destroy
            user.destroy
          end
        else
          email = ce.EmailAddr
          if !Account.all.find_by(code: code)
            if email.blank?
              email = counter
            end
            if !User.all.find_by(email: email)
              newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
              if newuser.save(validate: false) #false to skip validation
                newuser.add_role :user
                newaccount = Account.new(code: code, user: newuser) #create the account and associate with user
                newaccount.save
              end
            end
          end
        end
      end
      dbh.disconnect 


      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.Code.strip
        if Account.all.find_by(code: code)
          account = Account.all.find_by(code: code)
          compname = c.Name
          street = c.Street
          suburb = c.Suburb 
          state = c.Territory
          postcode = c.Postcode 
          phone = c.Phone 
          sort = c.Sort 
          discount = c.SpecialPriceCat 
          seller_level = c.PriceCat
          rep = c.SalesRep
          account.update_attributes(approved: 'approved', phone: phone, street: street, state: state, suburb: suburb, postcode: postcode, sort: sort, company: compname, rep: rep, seller_level: seller_level, discount: discount)
        end
      end
      dbh.disconnect 

      # --------------------- ADD EMAIL ADDRESSES ----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      contacts.each do |contact|
        if contact.Active == 1
          if account = Account.all.find_by(code: contact.Code.strip)
            if !User.all.find_by(email: contact.EmailAddress)
              email = contact.EmailAddress
              account.user.update_attributes(email: email)
            end
          end
        end
      end
      dbh.disconnect 

      #------------------------- SET DEFAULT SELLER LEVEL ---------------------
      unset = Account.all.where(seller_level: nil)
      unset.each do |acct|
        @results << 'found'
        acct.update_attributes(seller_level: '1')
      end


      #-------------------------- CREATE ADMIN USER -------------------------------------

      def createadmin(adminemail, admincode)
        if adminuser = User.all.find_by(email: adminemail)
          adminuser.add_role :admin
          adminuser.remove_role :user
          if adminuser.account
            adminuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
          else
            Account.create(code: admincode, company: 'Roc', user: adminuser, sort: 'U/L/R/P')
          end
        else
          adminuser = User.new(email: adminemail, password:'cloudy_16', password_confirmation: 'cloudy_16')
          adminuser.add_role :admin
          adminuser.save(validate: false)
          Account.create(code: admincode, company: 'Roc', user: adminuser, sort: 'U/L/R/P')
        end
      end
      createadmin('web@roccloudy.com', 'ADMIN')
      createadmin('office@roccloudy.com', 'OFFICE')

      #-------------------------- CREATE REP ACCOUNTS -----------------------------------
      def createrep(repemail, repcode)
        if repuser = User.all.find_by(email: repemail)
          repuser.add_role :rep
          repuser.remove_role :user
          if repuser.account
            repuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
          else
            Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
          end
        else
          repuser = User.new(email: repemail, password:'cloudy_16', password_confirmation: 'cloudy_16')
          repuser.add_role :rep
          repuser.save(validate: false)
          Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
        end
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