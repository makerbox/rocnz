class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       @discos = Discount.all
end
end