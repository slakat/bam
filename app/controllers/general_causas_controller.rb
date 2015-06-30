class GeneralCausasController < ApplicationController
  before_action :set_general_causa, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index

    @general_causas = current_user.account.general_causas.where.not(:causa_type => ["CorteCausa", "SupremaCausa"])
    respond_with(@general_causas)
  end

  def cortes
    @general_causas = current_user.account.general_causas.where(:causa_type => ["CorteCausa", "SupremaCausa"])
  end

  def show
    respond_with(@general_causa)
  end

  def new
    @general_causa = GeneralCausa.new
    respond_with(@general_causa)
  end

  def edit
  end

  def create
    @general_causa = GeneralCausa.new(general_causa_params)
    @general_causa.save
    respond_with(@general_causa)
  end

  def update
    @general_causa.update(general_causa_params)
    respond_with(@general_causa)
  end

  def destroy
    @general_causa.destroy
    respond_with(@general_causa)
  end

  def changes
    @changes = []
    current_user.account.general_causas.each do |gc|
      gc.causa_changes.each do |cc|
        @changes << cc
      end
    end    
  end

  private
    def set_general_causa
      @general_causa = GeneralCausa.find(params[:id])
    end

    def general_causa_params
      params.require(:general_causa).permit(:rol, :date, :caratulado, :tribunal)
    end
end
