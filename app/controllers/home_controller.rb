class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def test
  	@notice = 'routed'
  	system "git pull"
  	@notice = @notice + ' pulled'
  	@order = params[:order]
  end

end
