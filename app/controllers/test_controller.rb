class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	# -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------


  end
end
