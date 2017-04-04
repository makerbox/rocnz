class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	Product.all.each do |p|
  		@result << p.code
  	end
  	# AdminMailer.new_user_waiting_for_approval('web@roccloudy.com', Account.last).deliver_now
  end
end
