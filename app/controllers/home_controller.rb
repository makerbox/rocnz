class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

def pull
    system "git pull"

    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
  end

end
