class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@output = []
	  	counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @accounts = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @accounts.each do |acct|
        @output << (acct.InactiveCust.to_s + '--' + acct.Code.to_s)
      end





	  	Contact.all.find_by(code:'running').destroy
	  	Contact.all.find_by(code:'clock').destroy
	  	# @output = Contact.all.where(code:'clock')

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end