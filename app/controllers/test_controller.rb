class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	AdminMailer.new_user_waiting_for_approval('web@roccloudy.com', Account.first).deliver_now
  end
end
