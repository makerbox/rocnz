class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	EmailJob.perform_async('web@roccloudy.com')
  end
end
