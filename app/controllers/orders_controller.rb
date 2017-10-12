class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :sendorder]

  def sendorder
  @order.quantities.each do |q| # change stock levels and calc order total
    oldqty = q.product.qty
    newqty = oldqty - q.qty
    q.product.update(qty: newqty)
  end
  orderno = 'w' + (Order.count + 1).to_s
  sent = DateTime.now
  @order.update(active: false, sent: sent, total: params[:total], order_number: orderno) # move order to pending and give it a total
  
  @account = @order.user.account
  OrderEmailJob.perform_async(@order)

  if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic)
    current_user.mimic.destroy
  end

  redirect_to "http://218.214.73.21:3000/orders/#{@order.id}/kfime"
end

def kfime
  Order.all.last.kfi
  redirect_to "http://nz.roccloudy.com/home/confirm"
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
    @sellerlevel = @order.user.account.seller_level
    if user_signed_in?
      if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic) #for sidecart
        @order = current_user.mimic.account.user.orders.where(active: true).last #for sidecart
      else #for sidecart
        @order = current_user.orders.where(active: true).last #for sidecart
      end #for sidecart
    end
    if params[:id]
      @order = Order.find(params[:id])
      if params[:showcart] == 'show'
        @showbuttons = 'show'
      else
        @showbuttons = 'noshow'
      end
    end
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
    if (current_user.has_role? :admin) || (current_user.has_role? :rep)
      @order.order_number = current_user.account.code + Order.all.count.to_s
    else
      @order.order_number = Order.all.count.to_s
    end
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
        format.html { redirect_to @order.quantities.last.product, notice: 'Order was successfully updated.' }
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
      format.html { redirect_to home_index_path, notice: 'Order was successfully destroyed.' }
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
      params.require(:order).permit(:showcart, :total, :user_id, :notes, :cust_order_number, :order_number, :delivery_date)
    end
  end
