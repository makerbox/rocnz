class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
          contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
          contacts.each do |contact|
          	account = Account.all.find_by(code: contact.Code)
          	@results << contact.Code
          	@results << contact.Active
          	if contact.Active
          		@results << contact.EmailAddress
          	end
          	@results << '||'
          end

          dbh.disconnect 

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end