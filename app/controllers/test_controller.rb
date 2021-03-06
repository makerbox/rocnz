class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
        @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.Code.strip
        if account = Account.all.find_by(code: code)
            # account = Account.all.find_by(code: code)
            if c.InDispute == 1
                @results << account.code
                account.update(dispute: true)
            end
        end
      end
	end

end