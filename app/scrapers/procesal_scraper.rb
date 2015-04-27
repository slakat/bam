class ProcesalScraper
  
  def self.search_by_rut(input)
    rut = input.split('-')
  
   a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
  }

 a.get('http://corte.poderjudicial.cl/SITCORTEPORWEB/') do |page|
  # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

  # }.submit
  a.cookie_jar
  page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
end

page = a.post('http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoDAction.do', {
"TIP_Consulta"=>"4",
"TIP_Lengueta"=>"tdRut",
"TIP_Causa"=>"",
"COD_Libro"=>"",
"COD_Corte"=>"0",
"ROL_Recurso"=>"",
"ERA_Recurso"=>"",
"FEC_Desde"=>"26/04/2015",
"FEC_Hasta"=>"26/04/2015",
"NOM_Consulta"=>"",
"APE_Paterno"=>"",
"APE_Materno"=>"",
"selConsulta"=>"0",
"ROL_Causa"=>"",
"ERA_Causa"=>"",
"RUC_Era"=>"",
"RUC_Tribunal"=>"",
"RUC_Numero"=>rut[0],
"RUC_Dv"=>rut[1],
"irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:49; NUM_SalaUsuario=0; #{a.cookies[0]};"})


  @list=[]
  #puts page.search("table#filaSel tr").inner_text
  page.search('div#divRecursos table tr.textoPortal').each do |n|
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
    things = [properties[0].strip,properties[3],properties[4],properties[5],properties[6],properties[7]]
    @list << (things)
  end
  puts @list.first
  puts @list.first[0]
  puts @list.first[1]
  puts @list.first[2]
  puts @list.first[3]

  return @list

  end
  
  def self.search_by_name(a,b,c)
    name = a.upcase  
    last_name = b.upcase
    second_last_name = c.upcase
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf') do |page|
      # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      # }.submit
      a.cookie_jar
      #page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
    end

    page = a.post('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf', {
    "formConsultaCausas:idTabs"=>"idTabNombre",
    "formConsultaCausas:idValueRadio"=>"1",
    "formConsultaCausas:idFormRolInterno"=>"",
    "formConsultaCausas:idFormRolInternoEra"=>"",
    "formConsultaCausas:idSelectedCodeTipCauRef"=>"",
    "formConsultaCausas:idFormRolUnico"=>"",
    "formConsultaCausas:idFormRolUnicoDv"=>"",
    "formConsultaCausas:idSelectedCodeTribunal"=>"",
    "formConsultaCausas:tblListaParticipantes:s"=>"-1",
    "formConsultaCausas:tblListaRelaciones:s"=>"-1",
    "formConsultaCausas:tblListaTramites:s"=>"-1",
    "formConsultaCausas:tblListaNotificaciones:s"=>"-1",
    "formConsultaCausas:idFormNombres"=>"",
    "formConsultaCausas:idFormApPater"=>"alvear",
    "formConsultaCausas:idFormApMater"=>"",
    "formConsultaCausas:idFormFecEra"=>"2014",
    "formConsultaCausas:idSelectedCodeTribunalNom"=>"1231",
    "formConsultaCausas:buscar2.x"=>"50",
    "formConsultaCausas:buscar2.y"=>"9",
    "formConsultaCausas:tblListaConsultaNombres:s"=>"-1",
    "formConsultaCausas:tblListaParticipantesNom:s"=>"-1",
    "formConsultaCausas:tblListaRelacionesNom:"=>"-1",
    "formConsultaCausas:tblListaTramitesNom:s"=>"-1",
    "formConsultaCausas:tblListaNotificacionesNom:s"=>"-1",
    "formConsultaCausas:waitCargaSentOpenedState"=>"",
    "formConsultaCausas"=>"formConsultaCausas",
    "autoScroll"=>"",
    "javax.faces.ViewState"=>a.page.forms[0]['javax.faces.ViewState']})

    page.search(".texto").each do |n|
      puts n.content
    end

  @list=[]
    #puts page.search("table#filaSel tr").inner_text
    page.search('.texto').each do |n|
      properties = n.search('.td_GLS_RitC/text() a/text()','td/text()','.td_GLS_GeneralFecha/text()','td.td_GLS_GeneralMedium/text()','td.td_GLS_GeneralFecha/text()','td.td_GLS_GeneralMedium/text()','td.td_GLS_GeneralLong/text()').collect {|text| text.to_s}
      puts properties
    things = [properties[0].strip,properties[3],properties[4],properties[5],properties[6],properties[7]]
      @list << (things)
    end

    puts @list.first[0]
    puts @list.first[1]
    puts @list.first[2]
    puts @list.first[3]
    puts @list.first[4]
    puts @list.first[5]

    return @list


  end

end