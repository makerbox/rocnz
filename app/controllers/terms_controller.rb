class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []

    

  end #end def index

end #end class
