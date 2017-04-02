class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
    # User.destroy_all
    # Account.destroy_all
    # Contact.destroy_all
#-------------------------- CREATE ADMIN USER -------------------------------------
User.all.each do |p|
  if p.has_role? :admin
    @result << p.email
  end
end

#-------------------------- CREATE REP ACCOUNTS -----------------------------------
# dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
# @reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)
# @reps.each do |rep|
#   if rep.Inactive == 'N'
#     code = rep.Code
#     if email = rep.EmailAddress
#       repuser = User.new(email: email, password: 'cloudy_rep_123', password_confirmation: 'cloudy_rep_123')
#       if repuser.save(validate: false)
#         repaccount = Account.new(code: code, user: repuser)
#         repaccount.save
#         repuser.add_role :admin
#       end
#     end
#   end
# end
# dbh.disconnect

  end
end
