class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

def disc(p)
  d = Discount.where(product: p.group)
  if discount
    return d.discount
  end
end

  # GET /products
  # GET /products.json
  def index
    availgroups = [] #create empty array to store the groups available to the current user
    group = params[:group]
    filter = params[:filter]
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
          if params[:filter]
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
          if params[:filter]
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
          if params[:filter]
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
          if params[:filter]
            @products = @products.where(category: params[:filter])
          end
        else
          redirect_to home_index_path
        end
      elsif filter == 'new'
        @products = Product.where('new_date > ?', Date.today - 30.days).where(group: availgroups.to_a)
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
    if @products
      @products = @products.where("qty > ?", 20)
      @products = @products.order(group: 'DESC').order(code: 'ASC')
      @totalproducts = @products.count
      @order = current_user.orders.find_by(active: true)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @order = current_user.orders.find_by(active: true)
    @quantity = Quantity.new
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
