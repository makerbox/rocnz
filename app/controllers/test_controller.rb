class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@order.last.kfi
    redirect_to "http://roccloudy.com", alert: "order sent!"
  end
end