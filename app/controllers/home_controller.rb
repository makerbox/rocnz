class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

def pull
      @notice = 'routed'
    system "git pull"
    @notice = @notice + ' pulled'
    redirect_to :back
  end

  def test
  	if params[:order]
      @order = Order.find_by(id: params[:order])
      @print = "total:" + @order.total.to_s
      # @print += @order.total
      @order.quantities.each do |q|
        @print += q.product.name
        @print += q.product.price.to_s
      end
    else
      @order = "nothing came through - params empty"
    end
  end

end
