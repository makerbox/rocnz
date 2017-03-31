class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
    @result = User.all

  end
end
