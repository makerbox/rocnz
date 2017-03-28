class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	# -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

	Account.all.each do |acct|
  		@result << acct.user.email
  	end
  	User.all.find_by(email: 'web@roccloudy.com').destroy
  end
end
