class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def test
  	@notice = 'routed'
  	system "git pull"
  	@notice = @notice + ' pulled'
  	system "shell.ShellExecute('testprint.txt', '', '', 'print', 0)"
  	@notice = @notice + ' printed'
  	redirect_to :back
  end

end
