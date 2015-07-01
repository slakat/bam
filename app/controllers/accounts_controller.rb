class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :add_causa,:causas,:clients]
  load_and_authorize_resource
  respond_to :html

  def index
    @accounts = Account.all
    respond_with(@accounts)
  end

  def show
    respond_with(@account)
  end

  def new
    @account = Account.new
    respond_with(@account)
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    user = User.create(email:params[:email],password: '12345678')
    @account.user = user
    @account.save
    user.account = Account.last
    respond_with(@account)
  end

  def update
    @account.update(account_params)
    respond_with(@account)
  end

  def destroy
    @account.destroy
    respond_with(@account)
  end

  def causas
  end

  def clients
  end

  def search
    val = params[:c]
    laboral = (true if val=="1") || (true if val=="0") || false
    civil = (true if val=="2") || (true if val=="0") || false
    procesal = (true if val=="3") || (true if val=="0") || false
    corte = (true if val=="4") || (true if val=="0") || false
    suprema = (true if val=="5") || (true if val=="0") || false

    causas = GeneralCausa.search(params[:q],civil,laboral,procesal,corte,suprema)
    render json: causas.as_json()
  end

  def search_clients
    query_string = "%#{params[:q]}%"
    clients_arel      = Client.arel_table
    clients = Client.where((clients_arel[:rut].matches(query_string)).or(clients_arel[:name].matches(query_string)).or(clients_arel[:lastname].matches(query_string)))
    render json: clients.as_json()
  end

  def add_client
    c = Client.find(params[:client])
    unless @account.clients.include?(c)
      @account.clients << c
    end
    redirect_to request.referer
  end

  def add_causa
    causa = GeneralCausa.find(params[:causa])
    unless @account.general_causas.include?(causa)
      @account.general_causas << causa
    end
    redirect_to request.referer
  end

  def remove_causa
    causa = GeneralCausa.find(params[:causa])
    if @account.general_causas.include?(causa)
      @account.general_causas.delete(causa)
    end
    redirect_to request.referer
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :lastname, :rut,:user_causas, :role)
    end
end
