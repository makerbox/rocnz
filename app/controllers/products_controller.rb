class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json

def hide
  product = Product.all.find_by(id: params[:id])
  if product.hidden
    product.update_attributes(hidden: false)
  else
    product.update_attributes(hidden: true)
  end
  redirect_to :back
end

def calc_qty_disc
  price = (params[:price]).to_f
  prod_group = params[:group]
  prod_code = params[:code]
  price_cat = params[:pricecat]
  qty = params[:qty]
  
  if current_user.mimic
    u = current_user.mimic
  else
    u = current_user
  end
  
  if discos = Discount.all.where('(product = ? AND (producttype = ? OR producttype = ?)) OR (product = ? AND (producttype = ? OR producttype = ?)) OR (product = ? AND (producttype = ? OR producttype = ?))', price_cat, 'cat_fixed', 'cat_percent' , prod_code , 'code_fixed', 'code_percent', prod_group, 'group_fixed', 'group_percent').where('customer = ? OR customer = ?', u.account.code, u.account.discount)
    disco = discos.all.where('maxqty >= ?', qty).first
    if disco.disctype == 'fixedtype'
      result = disco.discount
    else
      result = price - ((price / 100) * disco.discount)
    end
  else
    result = price
  end
  respond_to do |format|
    format.json { render json: {result: result} }
  end
end

  def index
    availgroups = [] #create empty array to store the groups available to the current user
    group = params[:group]
    filter = params[:filter]
    if user_signed_in?
      if current_user.account.sort # check that they have a sort before trying to use include? statements
        if group == 'roc'
          if (current_user.account.sort.include? 'R') || ((current_user.has_role? :admin) || (current_user.has_role? :rep)) 
            @products = Product.where(group: ['C','J'])
            @categories = []
            @products.each do |p| # get a list of categories
              @categories << p.category
            end
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
          else
            redirect_to home_index_path
          end
        elsif group == 'polasports'
          if (current_user.account.sort.include? 'P') || ((current_user.has_role? :admin) || (current_user.has_role? :rep))
            @products = Product.where(group: ['L'])
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
          else
            redirect_to home_index_path
          end
        elsif group == 'locello'
          if (current_user.account.sort.include? 'L') || ((current_user.has_role? :admin) || (current_user.has_role? :rep))
            @products = Product.where(group: ['LC'])
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
          else
            redirect_to home_index_path
          end
        elsif group == 'unity'
          if (current_user.account.sort.include? 'U') || ((current_user.has_role? :admin) || (current_user.has_role? :rep))
            @products = Product.where(group: ['E', 'R', 'D', 'A', 'Z'])
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
          else
            redirect_to home_index_path
          end
        else
          if user_signed_in?
            if current_user.has_role? :admin
              @products = Product.all
            else
              @products = Product.all
              redirect_to home_index_url
            end
          else
            @products = Product.all
            redirect_to home_index_url
          end
        end
      else
        redirect_to home_index_path
      end
    else #if the user is not logged in, show everything (with no prices)
      if group == 'roc'
            @products = Product.where(group: ['C','J'])
            @categories = []
            @products.each do |p| # get a list of categories
              @categories << p.category
            end
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
      elsif group == 'polasports'
            @products = Product.where(group: ['L'])
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
        elsif group == 'locello'
            @products = Product.where(group: ['LC'])
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
        elsif group == 'unity'
            @products = Product.where(group: ['E', 'R', 'D', 'A', 'Z'])
            if params[:cat]
              @products = @products.where(group: params[:cat])
            end
            if (params[:filter]) && (params[:filter] != 'new')
              @products = @products.where(category: params[:filter])
            end
        end
    end

  if @products
    if params[:filter] == 'new'
      @products = @products.where("new_date >= ?", Date.today - 30.days)
    end
    # if group == 'unity' #qty must be over 20 for unity
      # @products = @products.where("qty > ?", 20)
    # else #qty must be over 5 for other brands
      # @products = @products.where("qty > ?", 5)
    # end
    @products = @products.order(group: 'DESC').order(code: 'ASC')
    @totalproducts = @products.count

    if user_signed_in?
      if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic) #for sidecart
        @order = current_user.mimic.account.user.orders.where(active: true).last #for sidecart
      else #for sidecart
        @order = current_user.orders.where(active: true).last #for sidecart
      end #for sidecart
    end

    if user_signed_in?
      if (current_user.has_role? :user) || (current_user.has_role? :rep) #hide hidden products for customers
        @products = @products.where(hidden: false)
      end
    end
  end
  if user_signed_in?
      if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic)
        @order = current_user.mimic.account.user.orders.where(active:true).last
      else
        @order = current_user.orders.where(active: true).last
      end
      @quantity = Quantity.new
  end
  if searchterm = params[:searchterm]
      @products = @products.where('lower(code) LIKE ? OR lower(description) LIKE ?', "%#{searchterm.downcase}%", "%#{searchterm.downcase}%")
  end
end

  # GET /products/1
  # GET /products/1.json
  def show
    if user_signed_in?
      if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic)
        @order = current_user.mimic.account.user.orders.where(active:true).last
      else
        @order = current_user.orders.where(active: true).last
      end
      @quantity = Quantity.new
    end
  end

  #add product to order
  # def add
  #   if current_user.orders.where(active: true)
  #     #if the user has an order open, then add the product to the order
  #     @product_order = ProductOrder.create(order: params[:order], product: params[:product], qty: params[:qty])
  #   else
  #     #otherwise, create a new order for the user
  #     Order.create(user: current_user)
  #     #add the product to the order (use product_order join table?)
  #   end
  # end

  #remove product from order
def remove
  @quantity = Quantity.find_by(id: params[:id])
  @quantity.destroy
  redirect_to :back
end

#add product to cart (used for popup ajax)
def add_product_to_cart
  qty = params[:qty]
  product_id = params[:product]
  order_id = params[:order_id]
  @newquantity = Quantity.new(qty: qty, product_id: product_id, order_id: order_id)
  @newquantity.brand = @newquantity.product.group
  if @newquantity.order == nil
  #if there is not active order to add this to, we will just make one
  if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic)
    @order = Order.create(user: current_user.mimic.account.user, active: true, approved: false, complete: false)
  else
    @order = Order.create(user: current_user, active: true, approved: false, complete: false)
  end
    #update the order to have an order number based on it's ID
    order_num = 'W' + @order.id.to_s
    @order.update(order_number: order_num)
    #and then add it to the new order
    @newquantity.order = @order
  end

  case @newquantity.product.group
  when 'C' , 'J'
    group = 'roc'
  when 'L'
    group = 'polasports'
  when 'LC'
    group = 'locello'
  when 'E' , 'R' , 'D' , 'A'
    group = 'unity'
  end
  if @newquantity.save
    htmlstring = ''
    thisproduct = Product.find(product_id)
    #get quantity data (price etc)
    if @newquantity.order.quantities.where(product: thisproduct).count > 1
      htmlstring += '<div class="po warning">Item already in cart<br>'
    else
     htmlstring += '<div class="po">'
   end
   htmlstring += '<a href="/products/' + product_id.to_s + '"><div class="product-thumbnail">'
   htmlstring += '<img src="http://res.cloudinary.com/ddmbp4xnw/image/upload/'+thisproduct.code.to_s+'.jpg">'
   htmlstring += '</div>'+thisproduct.code.to_s
   htmlstring += '</a>'
   if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (!current_user.mimic.nil?)
    level = current_user.mimic.account.seller_level.to_i
    thisperson = current_user.mimic.account.user
  else
    level = current_user.account.seller_level.to_i
    thisperson = current_user
  end
  case level
  when 1
    oldprice = thisproduct.price1
    prodprice = thisproduct.calc_discount(thisperson, thisproduct.price1, thisproduct.group, thisproduct.code, thisproduct.pricecat, qty)
  when 2
    oldprice = thisproduct.price2
    prodprice = thisproduct.calc_discount(thisperson, thisproduct.price2, thisproduct.group, thisproduct.code, thisproduct.pricecat, qty)
  when 3
    oldprice = thisproduct.price3
    prodprice = thisproduct.calc_discount(thisperson, thisproduct.price3, thisproduct.group, thisproduct.code, thisproduct.pricecat, qty)
  when 4
    oldprice = thisproduct.price4
    prodprice = thisproduct.calc_discount(thisperson, thisproduct.price4, thisproduct.group, thisproduct.code, thisproduct.pricecat), qty
  when 5
    oldprice = thisproduct.price5
    prodprice = thisproduct.calc_discount(thisperson, thisproduct.price5, thisproduct.group, thisproduct.code, thisproduct.pricecat, qty)
  when 6
    oldprice = thisproduct.rrp
    prodprice = thisproduct.rrp
  end

  htmlstring += '$'
  htmlstring += prodprice.to_s
  # htmlstring += number_with_precision(prodprice, precision: 2)
  subtotal = qty.to_i * prodprice

  htmlstring += '<div class="qty"> x '
  htmlstring += qty
  htmlstring += '<a href="' + edit_quantity_path(@newquantity.id) + '" class="fa fa-pencil-alt"></a>'
  htmlstring += '</div> ------- $'+subtotal.to_s
  htmlstring += '<a data-qty="'+qty+'" data-price="'+prodprice.to_s+'" data-disable-with="removing..." class="btn btn-warning remove-btn" data-remote="true" href="/products/' + @newquantity.id.to_s + '/remove" onclick="removeMe(this)">remove</a>' 
  htmlstring += '</div>'

  respond_to do |format|
    format.json { render json: {result: htmlstring.html_safe} }
  end
else

end
end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :price)
    end
  end
