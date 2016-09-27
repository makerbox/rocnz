class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def test
  	system "git pull"
  	system "shell.ShellExecute('testprint.txt', '', '', 'print', 0)"
  	redirect_to :back
  end

end
