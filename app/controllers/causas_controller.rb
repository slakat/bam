class CausasController < ApplicationController
  before_action :set_causa, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @causas = Causa.all
    respond_with(@causas)
  end

  def show
    respond_with(@causa)
  end

  def new
    @causa = Causa.new
    respond_with(@causa)
  end

  def edit
  end

  def create
    @causa = Causa.new(causa_params)
    @causa.save
    respond_with(@causa)
  end

  def update
    @causa.update(causa_params)
    respond_with(@causa)
  end

  def destroy
    @causa.destroy
    respond_with(@causa)
  end

  private
    def set_causa
      @causa = Causa.find(params[:id])
    end

    def causa_params
      params.require(:causa).permit(:rol, :date, :caratulado, :tribunal)
    end
end
