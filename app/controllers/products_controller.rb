class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]


  # GET /products
  # GET /products.json
  def index
    group = params[:group]
    if group == 'roc'
      @products = Product.where(group: ['C  '])
    elsif group == 'polasports'
      @products = Product.where(group: ['L  '])
    elsif group == 'locello'
      @products = Product.where(group: ['LC '])
    elsif group == 'unity'
      @products = Product.where(group: ['E  ', 'R  ', 'D  ', 'A  '])
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
    if params[:order]
      @accounts = @accounts.order(params[:order] + ' ASC')
    end
    @products = @products.paginate(:page => params[:page], :per_page => 12)

    @totalproducts = @products.count
    @order = current_user.orders.find_by(active: true)
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @order = current_user.orders.find_by(active: true)
  end

  #add product to order
  def add
    if current_user.orders.where(status: 'open')
    #if the user has an order open, then add the product to the order
  else
    #otherwise, create a new order for the user
    Order.create(user: current_user)
    #add the product to the order (use product_order join table?)
  end
  end

  #remove product from order
  def remove
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
