class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	# -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

	Account.all.each do |acct|
		if acct.user.has_role? :admin
	  		@result << acct.user.email
	  	end
  	end
  end
end
