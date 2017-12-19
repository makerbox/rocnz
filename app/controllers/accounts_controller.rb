class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :approve, :unapprove]
  before_action :securitycheck, only: [:index, :approve, :unapprove, :destroy]

#   check if user is admin - if not send them back home --- set which actions up top in the before_action
  def securitycheck
    if !((current_user.has_role? :admin) || (current_user.has_role? :rep))
      redirect_to home_index_path
    end
  end

def orderas
  if params[:account] == 'clear'
    current_user.mimic.destroy #if they choose to order as themselves, just wipe it clean
  else
    account = Account.find_by(id: params[:account])
    if current_user.mimic
      current_user.mimic.update(account: account) #if they are already mimicing, then just update
    else
      Mimic.create(account: account, user: current_user) #if they are fresh to a mimic, then creat the record
    end
  end
  redirect_to home_index_path
end

def approve
  @account.update_attributes(:approved => 'approved')
  UserMailer.approved_email(@account.user.email).deliver_now
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
      @accounts = Account.where('lower(company) LIKE ? OR lower(code) LIKE ?', "%#{searchterm.downcase}%", "%#{searchterm.downcase}%")
    else
      @accounts = Account.all.order(approved: :asc, created_at: :desc)
    end
    if params[:order]
      @accounts = @accounts.order(params[:order] + ' ASC')
    end
    if params[:search]
      @accounts = @accounts.where(code: params[:search])
    end
    case current_user.account.code
      when 'REPNSW'
        @accounts = @accounts.where('rep LIKE ? OR rep LIKE ?', '%GT%', '%GTS%')
      when 'REPVIC'
        @accounts = @accounts.where('rep LIKE ?', '%CC%')
      when 'REPQLD1'
        @accounts = @accounts.where('rep LIKE ? OR rep LIKE ?', '%SG%', '%SGW%')
      when 'REPQLD2'
        @accounts = @accounts.where('rep LIKE ? OR rep LIKE ? OR rep LIKE ?', '%SK%', '%SKT%', '%SKN%')
    end
    # if current_user.email != 'web@roccloudy.com'
    #   @accounts = @accounts.where(rep: current_user.account.code)
    # end
    @accounts = @accounts.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if (current_user.has_role? :admin) || (current_user.has_role? :rep)
      account = Account.find(params[:id])
      @pendingorders = Order.where(user: account.user, active: false, approved: false, complete: false)
      @approvedorders = Order.where(user:account.user, active:false, approved: true, complete: false)
      @sentorders = Order.where(user:account.user, active:false, approved: true, complete: true)
    else
      @pendingorders = Order.where(user: current_user, active: false, approved: false, complete: false)
      @approvedorders = Order.where(user:current_user, active:false, approved: true, complete: false)
      @sentorders = Order.where(user:current_user, active:false, approved: true, complete: true)
    end
    @pendingorders = @pendingorders.order(created_at: :desc).limit(5)
    @approvedorders = @approvedorders.order(created_at: :desc).limit(5)
    @sentorders = @sentorders.order(created_at: :desc).limit(5)
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
    @account.code = @account.company.upcase[0..5]
    i = 1
    until !Account.find_by(code: @account.code)
      newcode = @account.code + i.to_s
      if !Account.find_by(code: newcode)
        @account.code = newcode
      else
        i += 1
      end
    end 
    if Account.where("code LIKE CONCAT('%',?,'%')", @account.company.upcase[0..5]).count >= 2
        @alert = Account.where("code LIKE CONCAT('%',?,'%')", @account.code).first
        redirect_to warning_exists_path
    else
      respond_to do |format|
        if @account.save
          EmailJob.perform_async('cheryl@roccloudy.com', @account) #email admin with notification
          UserEmailJob.perform_async(@account.user.email) #email the user with a receipt

          format.html { redirect_to @account, notice: 'Account was successfully created.' }
          format.json { render :show, status: :created, location: @account }
        else
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        AdminMailer.account_change_request('office@roccloudy.com', @account).deliver_now
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
      params.require(:account).permit(:brands, :user_id, :website, :rep, :code, :company, :street, :suburb, :postcode, :state, :country, :phone, :contact, :seller_level, :sort, :discount)
    end
end
