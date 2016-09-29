class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

def pull
      @notice = 'routed'
    system "git pull"
    @notice = @notice + ' pulled'
    current_user.account.destroy
    redirect_to :back
  end

  def test
  	if params[:order]
      @order = Order.find_by(id: params[:order])
      if @order.user.account.company 
        company = @order.user.account.company
      else
        company = 'no company'
      end
      @print = "NEW ORDER FROM " + company + "`r`n"
      @print += "total: $" + @order.total.to_s + " ||| "
      @order.quantities.each do |q|
        product = Product.find_by(id: q.product_id)
        case current_user.account.seller_level.to_i
        when 1
          @setprice = product.price1
        when 2
          @setprice = product.price2
        when 3
          @setprice = product.price3
        when 4
          @setprice = product.price4
        when 5
          @setprice = product.price5
        when 6
          @setprice = product.rrp
        end
        @print += product.code.to_s + ' $' + @setprice.to_s + ' x ' + q.qty.to_s + '`r`n||'
        current_user.account.seller_level
      end
    else
      @order = "nothing came through - params empty"
    end
  end

end
