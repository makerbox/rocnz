class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@results = []
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
		contacts.each do |contact|
			if contact.Active == 1
				account = Account.all.find_by(code: contact.Code.strip)
				if account
						account.user.update_attributes(email: contact.EmailAddress)
						@results << account.user.email
						@results << account.code
						
				end
			end
		end
		dbh.disconnect 

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	  end
	end