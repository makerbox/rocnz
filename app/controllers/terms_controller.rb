class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []

    Discount.all.each do |d|
      @results << d.customer
      @results << d.product
      @results << d.discount
    end

  end #end def index

end #end class
