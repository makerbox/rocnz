class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
#-------------------------- CREATE REP ACCOUNTS -----------------------------------
    @reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)
      @reps.each do |rep|
        @result << rep.Inactive
        if rep.Inactive == 'N'
          code = rep.Code
          email = rep.EmailAddress
          repuser = User.new(email: email, password: 'cloudy_rep_123', password_confirmation: 'cloudy_rep_123')
          if repuser.save(validate: false)
            @result << repuser.email
            repaccount = Account.new(code: code, user: repuser)
            repaccount.save
            repuser.add_role :admin
          end
        end
    end

  end
end
