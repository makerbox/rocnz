class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :sendorder]


def sendorder
  @order.quantities.each do |q| # change stock levels and calc order total
    oldqty = q.product.qty
    newqty = oldqty - q.qty
    q.product.update(qty: newqty)
  end
  @order.update(active: false, sent: DateTime.now, total: params[:total]) # move order to pending and give it a total
  

  # OrderMailer.order(@order).deliver_now

  account = @order.user.account
  
  if account.company # start putting together printable order
    company = account.company
  else
    company = 'no company ' + account.phone #if no company name, then show phone number instead
  end
  @print = "<h1>New order from Roc Cloudy Wholesale Portal</h1>
  [ordered at: #{Time.now.strftime('%d/%m/%Y || %r')}]"
  if current_user.has_role? :admin
    @print += "<b> ordered by " + current_user.account.name.to_s + "</b>"
  end
  @print += "Company: " + company + "<hr>"
  @print += account.street.to_s + ' | ' + account.suburb.to_s + ' | ' + account.phone.to_s + "<hr>
  <table><thead>
  <tr>
  <th>CODE</th><th>PRICE</th><th>QTY</th>
  </tr>
  </thead>
  <tbody>"
  @order.quantities.each do |q|
    product = Product.find_by(id: q.product_id)
    if (current_user.has_role? :admin) && (!current_user.mimic.nil?) 
    level = current_user.mimic.account.seller_level.to_i 
    else 
    level = current_user.account.seller_level.to_i 
    end 
    case level
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
    @setprice = @setprice.round(2)
    @print += "<tr>
    <td>#{product.code.to_s}</td><td>$#{@setprice.to_s}</td><td>#{q.qty.to_s}</td>
    </tr>"
  end
  @print += "</tbody></table>"
  @print += "<h2>total: $" + @order.total.to_s + "</h2>"
  system 'printhtml html="'+@print+'"'
  redirect_to home_confirm_path
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
