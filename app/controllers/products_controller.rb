class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!
  # GET /products
  # GET /products.json

def calc_qty_disc
  qty = params[:qty]
  price = params[:qtyprice]
  if current_user.mimic
    u = current_user.mimic.user
  else
    u = current_user
  end
  # prod_group = @product.group
  # prod_code = @product.code
  # price_cat = @product.pricecat

  # if disco = Discount.all.find_by(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip)).find_by("maxqty >= ?", qty)
  #   result = price - disco
  # else
  #   result = price
  # end
  result = price + qty
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
        # if current_user.account.sort.include? 'R'
        #   availgroups = availgroups << 'C  '
        # end
        # if current_user.account.sort.include? 'P'
        #   availgroups = availgroups << 'L  '
        # end
        # if current_user.account.sort.include? 'L'
        #   availgroups = availgroups << 'LC  '
        # end
        # if current_user.account.sort.include? 'U'
        #   availgroups = availgroups << 'E  ' << 'R  ' << 'D  ' << 'A  '
        # end
        if group == 'roc'
          if (current_user.account.sort.include? 'R') || (current_user.has_role? :admin)
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
          if (current_user.account.sort.include? 'P') || (current_user.has_role? :admin)
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
          if (current_user.account.sort.include? 'L') || (current_user.has_role? :admin)
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
          if (current_user.account.sort.include? 'U') || (current_user.has_role? :admin)
            @products = Product.where(group: ['E', 'R', 'D', 'A'])
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
            @products = Product.where(group: ['E', 'R', 'D', 'A'])
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
    @products = @products.where("qty > ?", 20)
    @products = @products.order(group: 'DESC').order(code: 'ASC')
    @totalproducts = @products.count

    if user_signed_in?
      if (current_user.has_role? :admin) && (current_user.mimic) #for sidecart
        @order = current_user.mimic.account.user.orders.where(active: true).last #for sidecart
      else #for sidecart
        @order = current_user.orders.where(active: true).last #for sidecart
      end #for sidecart
    end
  end

end

  # GET /products/1
  # GET /products/1.json
  def show
    if user_signed_in?
      if (current_user.has_role? :admin) && (current_user.mimic)
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
