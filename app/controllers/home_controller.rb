class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def test
  	@notice = 'routed'
  	system "git pull"
  	@notice = @notice + ' pulled'
  	if params[:order]
      @order = params[:order]
    end
  end

end
