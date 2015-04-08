class MovimientosController < ApplicationController
  before_action :set_movimiento, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @movimientos = Movimiento.all
    respond_with(@movimientos)
  end

  def show
    respond_with(@movimiento)
  end

  def new
    @movimiento = Movimiento.new
    respond_with(@movimiento)
  end

  def edit
  end

  def create
    @movimiento = Movimiento.new(movimiento_params)
    @movimiento.save
    respond_with(@movimiento)
  end

  def update
    @movimiento.update(movimiento_params)
    respond_with(@movimiento)
  end

  def destroy
    @movimiento.destroy
    respond_with(@movimiento)
  end

  private
    def set_movimiento
      @movimiento = Movimiento.find(params[:id])
    end

    def movimiento_params
      params.require(:movimiento).permit(:dato1, :dato2)
    end
end
