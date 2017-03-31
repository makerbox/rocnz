class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
    User.destroy_all

  end
end
