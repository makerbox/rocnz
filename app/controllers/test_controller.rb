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
		@result = ''
    @discounts = []

    # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    # @discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    # dbh.disconnect

  end
end