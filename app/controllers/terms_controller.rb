class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    Product.all.each do |p|
      @results << p.category
    end
  end #end def index

end #end class
