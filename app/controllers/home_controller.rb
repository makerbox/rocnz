class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end
  
  def test
  	system "git pull"
  	Rake::Task['runner:testshell'].invoke
  	redirect_to :back
  end

end
