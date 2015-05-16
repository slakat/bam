class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
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
    @account.save
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

  def search

    causas_arel      = LaboralCausa.arel_table
    query_string = "%#{params[:q]}%"

    causas = LaboralCausa.where((causas_arel[:rit].matches(query_string)).or(causas_arel[:ruc].matches(query_string)).or(causas_arel[:caratulado].matches(query_string)).or(causas_arel[:tribunal].matches(query_string)))


    render json: causas
  end

  def add_causa
    causa = GeneralCausa.find(params[:causa])
    @account.general_causas << causa
  end

  def remove_causa
    causa = GeneralCausa.find(params[:causa])
    #@account.general_causas.
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :lastname, :rut)
    end
end
