class QuantitiesController < ApplicationController
  before_action :set_quantity, only: [:show, :edit, :update, :destroy]

  # GET /quantities
  # GET /quantities.json
  def index
    @quantities = Quantity.all
  end

  # GET /quantities/1
  # GET /quantities/1.json
  def show
  end

  # GET /quantities/new
  def new
    @quantity = Quantity.new
  end

  # GET /quantities/1/edit
  def edit
  end

  # POST /quantities
  # POST /quantities.json
  def create
    @quantity = Quantity.new(quantity_params)
    if @quantity.order == nil
    #if there is not active order to add this to, we will just make one
    if current_user.has_role? :admin
      @order = Order.create(user: current_user.mimic.account.user, active: true, approved: false, complete: false)
    else
      @order = Order.create(user: current_user, active: true, approved: false, complete: false)
    end
      #and then add it to the new order
      @quantity.order = @order
    end

    case @quantity.product.group
      when 'C' || 'J'
        group = 'roc'
      when 'L'
        group = 'polasports'
      when 'LC'
        group = 'locello'
      when 'E' || 'R' || 'D' || 'A'
        group = 'unity'
    end
    respond_to do |format|
      if @quantity.save
        format.html { redirect_to products_path(group: group), notice: 'Successfully added to order.' }
        format.json { render :show, status: :created, location: @quantity }
      else
        format.html { render :new }
        format.json { render json: @quantity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quantities/1
  # PATCH/PUT /quantities/1.json
  def update
    respond_to do |format|
      if @quantity.update(quantity_params)
        format.html { redirect_to @quantity, notice: 'Quantity was successfully updated.' }
        format.json { render :show, status: :ok, location: @quantity }
      else
        format.html { render :edit }
        format.json { render json: @quantity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quantities/1
  # DELETE /quantities/1.json
  def destroy
    @quantity.destroy
    respond_to do |format|
      format.html { redirect_to quantities_url, notice: 'Quantity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quantity
      @quantity = Quantity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quantity_params
      params.require(:quantity).permit(:qty, :product_id, :order_id)
    end
end
