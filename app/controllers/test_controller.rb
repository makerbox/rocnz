class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
    dbh = RDBI.connect :ODBC, :db => "wholesaleportalnz"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.Code.strip
        if Account.all.find_by(code: code)
          account = Account.all.find_by(code: code)
          @results << account.code
          account.update(dispute: c.InDispute)
        end
      end
	end

end