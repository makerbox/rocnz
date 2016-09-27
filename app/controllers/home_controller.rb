class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def test
  	@notice = 'routed'
  	system "git pull"
  	@notice = @notice + ' pulled'
  	system "PowerShell"
  	system "echo testing print please show this to Matt | out-printer"
  	@notice = @notice + ' printed'
  	puts @notice
  	redirect_to :back
  end

end
