class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :sendorder]


def sendorder
  @order.quantities.each do |q| # change stock levels and calc order total
    oldqty = q.product.qty
    newqty = oldqty - q.qty
    q.product.update(qty: newqty)
  end
  @order.update(active: false, sent: DateTime.now, total: params[:total]) # move order to pending and give it a total
  
  account = @order.user.account
  if account.company # start putting together printable order
    company = account.company
  else
    company = 'no company ' + account.phone #if no company name, then show phone number instead
  end
  @print = "NEW ORDER FROM ROC CLOUDY WHOLESALE PORTAL ["+ Time.now.strftime("%d/%m/%Y || %r") +"] \r\n"
  @print += "------------------------------------------------------------------- \r\n"
  @print += "THIS IS A TEST (please diregard) - order from " + company + "\r\n"
  @print += "------------------------------------------------------------------- \r\n"
  @print += account.street + ' | ' + account.suburb + ' | ' + account.state + ' | ' + account.phone + "\r\n"
  @print += "------------------------------------------------------------------- \r\n\n"
  @order.quantities.each do |q|
    product = Product.find_by(id: q.product_id)
    case current_user.account.seller_level.to_i
      when 1
        @setprice = product.price1 / 100 * product.discount(current_user)
      when 2
        @setprice = product.price2 / 100 * product.discount(current_user)
      when 3
        @setprice = product.price3 / 100 * product.discount(current_user)
      when 4
        @setprice = product.price4 / 100 * product.discount(current_user)
      when 5
        @setprice = product.price5 / 100 * product.discount(current_user)
      when 6
        @setprice = product.rrp / 100 * product.discount(current_user)
    end
    @print += "~" + product.code.to_s + "\r\n[" + product.description.strip + "]\r\n$" + @setprice.to_s + " x qty:" + q.qty.to_s + "\r\n\n"
  end
  @print += "-------------------------------------------------------------------\r\n"
  @print += "total: $" + @order.total.to_s + "\r\n"
  @print += "-------------------------------------------------------------------"
  `PowerShell -Command "echo '#{@print}' | out-printer"` # print order
  redirect_to account_path(current_user.account)
end

# def cart #if there aren't any active orders, then create one
#   product = Product.find_by(id: params[:product])
#   order = Order.create(user: current_user, active: true)
#   qty = params[:qty]
#   ProductOrder.create(order: order, product: product, qty: qty)
#   redirect_to product, notice: 'successfully added to order'
# end

# def addto
#   product = Product.find_by(id: params[:product])
#   order = current_user.orders.where(active: true).last
#   qty = params[:qty]
#   ProductOrder.create(order: order, product: product, qty: qty)
#   redirect_to product, notice: 'successfully added to order'
# end

  # GET /orders
  # GET /orders.json
  def index
    # being rendered in Account view, so moved to Account controller:
    # @orders = Order.all.where(user: current_user)
    # @orders = @orders.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:total, :user_id)
    end
end
