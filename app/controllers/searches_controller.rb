class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @searches = Search.all
    respond_with(@searches)
  end

  def show
    respond_with(@search)
  end

  def new
    @search = Search.new
    respond_with(@search)
  end

  def edit
  end

  def create
    @search = Search.new(search_params)
    @search.save
    respond_with(@search)
  end

  def update
    @search.update(search_params)
    respond_with(@search)
  end

  def destroy
    @search.destroy
    respond_with(@search)
  end
  
  def raw
  end
  
  def search_rut_scraper
    @listado= LaboralScraper.search_by_rut(params[:rut])
  end
  
  def search_name_scraper
    @listado= LaboralScraper.search_by_name(params[:name],params[:last_name],params[:second_last_name])
  end
  
    def search_rut_civil
    @listado= CivilScraper.search_by_rut(params[:rut])
  end

  private
    def set_search
      @search = Search.find(params[:id])
    end

    def search_params
      params.require(:search).permit(:term)
    end
end
