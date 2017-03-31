class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []


  end
end
