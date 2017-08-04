class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       @lastdiscount = Discount.all.last
  end
end