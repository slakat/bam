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

    courses_arel      = Account.arel_table
    query_string = "%#{params[:q]}%"

    courses = Account.where(courses_arel[:name].matches(query_string))
    courses.each do |s|
      puts s.name
    end
    puts courses_arel

    render json: courses
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :lastname, :rut)
    end
end
