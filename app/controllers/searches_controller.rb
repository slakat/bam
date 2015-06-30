class SearchesController < ApplicationController
  before_action :set_search, only: [ :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @searches = Search.all
    respond_with(@searches)
  end

  def search
    @causas = GeneralCausa.search(params[:q],params[:civil],params[:laboral],params[:procesal],params[:corte],params[:suprema])

    competencias = "c: "
    if params[:civil]
      competencias = "[Civil]"
    end

    if params[:laboral]
      competencias = competencias+"  [Laboral]"
    end

    if params[:procesal]
      competencias = competencias+"  [Ref. Procesal]"
    end

    if params[:corte]
      competencias = competencias+"  [C. de Apelaciones]"

    end
    if params[:suprema]
      competencias = competencias+" [C. Suprema]"
    end

    if current_user
      user= current_user.email
    else
      user= "Invitado"
    end

    SearchRecord.create!(query: params[:q],competencias:competencias,user:user)

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
    redirect_to(@search)
  end

  def update
    @search.update(search_params)
    respond_with(@search)
  end

  def destroy
    @search.destroy
    respond_with(@search)
  end
  
  def raw_laboral
  end
  
  def raw_civil
  end

  def raw_corte
  end

  def raw_procesal
  end

  def raw_suprema
  end

  
  def search_rut_laboral
    @listado= LaboralScraper.search_by_rut(params[:rut])
    @type = 0
    render 'search_results'
  end
  
  def search_name_laboral
    @listado= LaboralScraper.search_by_name(params[:name],params[:last_name],params[:second_last_name])
    @type = 0
    render 'search_results'
  end
  
  def search_rut_civil
    @listado= CivilScraper.search_by_rut(params[:rut])
    @type = 1
    render 'search_results'
  end

  def search_name_civil
    @listado= CivilScraper.search_by_name(params[:name],params[:last_name],params[:second_last_name])
    @type = 1
    render 'search_results'
  end

  def search_rut_corte
    @listado= CorteScraper.search_by_rut(params[:rut])
    @type = 2
    render 'search_results'
  end

  def search_name_corte
    @listado= CorteScraper.search_by_name(params[:name],params[:last_name],params[:second_last_name])
    @type = 2
    render 'search_results'
  end

    def search_rut_procesal
    @listado= ProcesalScraper.search_by_rut(params[:rut])
    @type = 3
    render 'search_results'
  end

  def search_name_procesal
    @listado= ProcesalScraper.search_by_name(params[:name],params[:last_name],params[:second_last_name])
    @type = 3
    render 'search_results'
  end

  def search_rut_suprema
    @listado= SupremaScraper.search_by_rut(params[:rut])
    @type = 4
    render 'search_results'
  end

  def search_name_suprema
    @listado= SupremaScraper.search_by_name(params[:name],params[:last_name],params[:second_last_name])
    @type = 4
    render 'search_results'
  end

  private
    def set_search
      @search = Search.find(params[:id])
    end

    def search_params
      params.require(:search).permit(:q,:civil,:laboral,:procesal,:corte,:suprema)
    end
end
