class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :approve, :unapprove]
  before_action :securitycheck, only: [:index, :approve, :unapprove, :destroy]

#   check if user is admin - if not send them back home --- set which actions up top in the before_action
  def securitycheck
    if !current_user.has_role? :admin
      redirect_to home_index_path
    end
  end

def orderas
  account = Account.find_by(id: params[:account])
  if current_user.mimic
    current_user.mimic.update(account: account)
  else
    Mimic.create(account: account, user: current_user)
  end
  redirect_to home_index_path
end

def approve
  @account.update_attributes(:approved => 'approved')
  redirect_to accounts_path, notice: 'Account approved'
end
def unapprove
  @account.update_attributes(:approved => 'unapproved')
  redirect_to accounts_path, notice: 'Account unapproved'
end

  # GET /accounts
  # GET /accounts.json
  def index    
    if params[:searchterm]
      searchterm = params[:searchterm]
      @accounts = Account.where('company LIKE ?', "%#{searchterm}%")
    else
      @accounts = Account.all.order('company desc')
    end
    if params[:order]
      @accounts = @accounts.order(params[:order] + ' ASC')
    end
    if params[:search]
      @accounts = @accounts.where(code: params[:search])
    end
    @accounts = @accounts.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if current_user.has_role? :admin
      account = Account.find(params[:id])
      @pendingorders = Order.where(user: account.user, active: false, approved: false, complete: false)
    @approvedorders = Order.where(user:current_user.mimic.account.user, active:false, approved: true, complete: false)
    @sentorders = Order.where(user:current_user.mimic.account.user, active:false, approved: true, complete: true)
    else
    @pendingorders = Order.where(user: current_user, active: false, approved: false, complete: false)
    @approvedorders = Order.where(user:current_user, active:false, approved: true, complete: false)
    @sentorders = Order.where(user:current_user, active:false, approved: true, complete: true)
  end
    # @sentorders = @sentorders.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user = current_user
    respond_to do |format|
      if @account.save
        # code for sending email notifications
         EmailJob.perform_async('cheryl@roccloudy.com, web@roccloudy.com') #email the request to admin for approval
         UserEmailJob.perform_async(@account.user.email) #email the user with a receipt
         
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:user_id, :rep, :code, :company, :street, :suburb, :postcode, :state, :country, :phone, :contact, :seller_level, :sort, :discount)
    end
end
