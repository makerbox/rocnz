class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@order.last.create_kfi
  end
end