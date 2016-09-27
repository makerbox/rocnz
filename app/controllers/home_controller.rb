class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end
  def test(name)
  	system "git pull"
  	Rake::Task[name].invoke
  	redirect_to :back
  end

end
