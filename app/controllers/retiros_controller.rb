class RetirosController < ApplicationController
  before_action :set_retiro, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @retiros = Retiro.all
    respond_with(@retiros)
  end

  def show
    respond_with(@retiro)
  end

  def new
    @retiro = Retiro.new
    respond_with(@retiro)
  end

  def edit
  end

  def create
    @retiro = Retiro.new(retiro_params)
    @retiro.save
    respond_with(@retiro)
  end

  def update
    @retiro.update(retiro_params)
    respond_with(@retiro)
  end

  def destroy
    @retiro.destroy
    respond_with(@retiro)
  end

  private
    def set_retiro
      @retiro = Retiro.find(params[:id])
    end

    def retiro_params
      params.require(:retiro).permit(:cuaderno, :data_retiro, :status)
    end
end
