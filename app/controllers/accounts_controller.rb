class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :approve, :unapprove]
  before_action :securitycheck, only: [:index, :approve, :unapprove, :destroy]

#   check if user is admin - if not send them back home --- set which actions up top in the before_action
  def securitycheck
    if !current_user.has_role? :admin
      redirect_to home_index_path
    end
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
    @accounts = Account.all.order('created_at desc')
    if params[:order]
      @accounts = @accounts.order(params[:order] + ' ASC')
    end
    @accounts = @accounts.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @pendingorders = Order.where(user: current_user, active: false, approved: false, complete: false)
    @approvedorders = Order.where(user:current_user, active:false, approved: true, complete: false)
    @sentorders = Order.where(user:current_user, active:false, approved: true, complete: true)
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
 #        @admin_user_emails = ''
 #        User.all.each do |u|
 #          if u.has_role? :admin
 #            @admin_user_emails << u.email + ','
 #          end
 #        end 
 # EmailJob.perform_async(@admin_user_emails)
 # UserEmailJob.perform_async(@account.user.email)

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
      params.require(:account).permit(:user_id, :company, :street, :suburb, :postcode, :state, :country, :phone, :contact, :seller_level)
    end
end
