class CorteScraper
  
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
"TIP_Consulta"=>"2",
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
"RUT_Consulta"=>rut[0],
"RUT_DvConsulta"=>rut[1],
"irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:49; NUM_SalaUsuario=0; #{a.cookies[0]};"})


  @list=[]
  #puts page.search("table#filaSel tr").inner_text
  page.search('div#divRecursos table tr.textoPortal').each do |n|
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
    things = [properties[0].strip,properties[3],properties[4],properties[5],properties[6],properties[7]]
    things << n.search('td a').map{|link| link['href']}.first.strip
    @list << (things)
  end
  puts @list.first

  return @list

  end
  
  def self.search_by_name(a,b,c)
    name = a.upcase  
    last_name = b.upcase
    second_last_name = c.upcase
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
    "TIP_Consulta"=>"3",
    "TIP_Lengueta"=>"tdNombre",
    "TIP_Causa"=>"",
    "COD_Libro"=>"null",
    "COD_Corte"=>"0",
    "ROL_Recurso"=>"",
    "ERA_Recurso"=>"",
    "FEC_Desde"=>"26/04/2015",
    "FEC_Hasta"=>"26/04/2015",
    "NOM_Consulta"=>name,
    "APE_Paterno"=>last_name,
    "APE_Materno"=>second_last_name,
    "selConsulta"=>"0",
    "ROL_Causa"=>"",
    "ERA_Causa"=>"",
    "RUC_Era"=>"",
    "RUC_Tribunal"=>"",
    "RUC_Numero"=>"",
    "RUC_Dv"=>"",
    "RUT_Consulta"=>"",
    "RUT_DvConsulta"=>"",
    "irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:49; NUM_SalaUsuario=0; #{a.cookies[0]};"})


  @list=[]
    #puts page.search("table#filaSel tr").inner_text
  page.search('div#divRecursos table tr.textoPortal').each do |n|
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
    things = [properties[0],properties[3],properties[4],properties[5],properties[6],properties[7]]
    things << n.search('td a').map{|link| link['href']}.first.strip



    b = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    page = b.post('http://corte.poderjudicial.cl'+things.last)

    #puts page.content

    doc = page.search('table.textoPortal tr')

    level_2 = doc[0].search('td')
    libro= level_2[1].text.split(':')[1].strip
    est_recurso = level_2[2].text.split(':')[1].strip
    fecha = level_2[3].text.split(':')[1].strip


    level_3 = doc[2].search('td')
    ubicacion = level_3[0].text.split(':')[1].strip
    est_procesal = level_3[1].text.split(':')[1].strip

    puts libro,est_recurso,fecha, ubicacion,est_procesal


    litigantes = []

    page.search('#divLitigantes tr.textoPortal').each do |l|
      data = []
      l.search('td').each_with_index do |a,index|

        data << a.text.strip
      end
      litigantes << data
    end
    puts litigantes

    #expediente
    level_4 = doc[6].search('td')
    rol_rit= level_4[0].text.split(':')[1].strip
    ruc = level_4[1].text.split(':')[1].strip
    fecha = level_4[2].text.split(':')[1].strip
    caratulado = doc[7].search('td')[0].text.split(':')[1].strip
    tribunal =  doc[9].search('td')[0].text.split(':')[1].strip

    puts rol_rit,ruc, fecha,caratulado,tribunal

    break

    @list << (things)
    end

    puts @list.first

    return @list


  end

end