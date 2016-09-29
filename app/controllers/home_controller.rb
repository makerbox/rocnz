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
      @order = Order.find_by(params[:order])
      @print = "new order total:"
      # @print += @order.total
      @order.quantities.each do |q|
        @print += q.qty.to_s
        # @print += q.product.name
        # @print += q.product.price
      end
    else
      @order = "nothing came through - params empty"
    end
  end

end
