class SupremaScraper
  
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

    a.get('http://suprema.poderjudicial.cl/') do |page|
      search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      }.submit

      a.cookie_jar
      #page = a.get("http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")

    end

    page = a.post('http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoDAction.do', {
    "TIP_Consulta"=>"3",
    "TIP_Lengueta"=>"tdNombre",
    "IP_Causa"=>"",
    "COD_Libro"=>"0",
    "COD_Corte"=>"1",
    "COD_Corte_AP"=>"0",
    "ROL_Recurso"=>"",
    "ERA_Recurso"=>"",
    "FEC_Desde"=>"26/04/2015",
    "FEC_Hasta"=>"26/04/2015",
    "TIP_Litigante"=>"999",
    "TIP_Persona"=>"N",
      "APN_Nombre"=>"",
      "APE_Paterno"=>"alvear",
      "APE_Materno"=>"",
    "COD_CorteAP_Sda"=>"0",
    "COD_Libro_AP"=>"0",
    "ROL_Recurso_AP"=>"",
    "ERA_Recurso_AP"=>"",
    "selConsulta"=>"0",
    "ROL_Causa"=>"",
    "ERA_Causa"=>"",
    "RUC_Era"=>"",
    "RUC_Tribunal"=>"",
    "RUC_Numero"=>"",
    "RUC_Dv"=>"",
    "COD_CorteAP_Pra"=>"0",
    "GLS_Caratulado_Recurso"=>"",
    "irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=1; COD_Usuario=autoconsulta; GLS_Corte=Corte Suprema; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:29; NUM_SalaUsuario=0; JSESSIONID=00003ZxmA6DnNKXIVGmzdke0TNO:-1; #{a.cookies[0]};"})


  @list=[]
    #puts page.search("table#filaSel tr").inner_text
    puts page.content
    page.search('table#contentCells tr.text').each do |n|
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
      
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