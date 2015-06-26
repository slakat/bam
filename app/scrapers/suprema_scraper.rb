class SupremaScraper
  
  def self.search_by_rut(input)
    rut = input.split('-')
  
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
"TIP_Consulta"=>"2",
"TIP_Lengueta"=>"tdRut",
"IP_Causa"=>"",
"COD_Libro"=>"0",
"COD_Corte"=>"1",
"COD_Corte_AP"=>"0",
"ROL_Recurso"=>"",
"ERA_Recurso"=>"",
"FEC_Desde"=>"15/04/2015",
"FEC_Hasta"=>"15/04/2015",
"TIP_Litigante"=>"999",
"TIP_Persona"=>"N",
"APN_Nombre"=>"",
"APE_Paterno"=>"",
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
"RUT_Consulta"=>rut[0],
"RUT_DvConsulta"=>rut[1],
"COD_CorteAP_Pra"=>"0",
"GLS_Caratulado_Recurso"=>"",
"irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=1; COD_Usuario=autoconsulta; GLS_Corte=Corte Suprema; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:29; NUM_SalaUsuario=0; JSESSIONID=00003ZxmA6DnNKXIVGmzdke0TNO:-1; #{a.cookies[0]};"})

  @list=[]
  #puts page.search("table#filaSel tr").inner_text
  puts page.content
  page.search('table#contentCells tr').each do |n|
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
    things = [properties[1].strip, properties[2],properties[3],properties[4],properties[5],properties[6],properties[7]]
    things << n.search('td a').map{|link| link['href']}.first.strip     
    @list << (things)
    puts n.body
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

    a.get('http://suprema.poderjudicial.cl/') do |page|
      search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      }.submit

      a.cookie_jar
      page = a.get("http://suprema.poderjudicial.cl/SITSUPPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")

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
      "APN_Nombre"=>name,
      "APE_Paterno"=>last_name,
      "APE_Materno"=>second_last_name,
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
    page.search('table#contentCells tr.texto').each do |n|
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
    #puts n
    things = [properties[1].strip,properties[2],properties[3],properties[4],properties[5],properties[6],properties[7]]
    things << n.search('td a').map{|link| link['href']}.first.strip


    b = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    page = b.post('http://suprema.poderjudicial.cl'+things.last)

    #puts page.content

    doc = page.search('table.texto tr')


    level_2 = doc[2].search('td')

    #puts level_2
    libro= level_2[1].text.split(':')[1].strip
    est_recurso = level_2[2].text.split(':')[1].strip
    fecha = level_2[3].text.split(':')[1].split('     Hora')[0].strip


    level_3 = doc[4].search('td')
    ubicacion = level_3[0].text.split(':')[1].strip
    est_procesal = level_3[1].text.split(':')[1].strip

    puts libro,est_recurso,fecha, ubicacion,est_procesal


    litigantes = []

    page.search('#contentCellsLitigantes tr.texto').each do |l|
      data = []
      l.search('td').each_with_index do |a,index|

        data << a.text.strip
      end
      litigantes << data
    end
    puts litigantes

    #expediente primera instancia
    doc = page.search('div#expediente1').search('table.texto tr')
    level_4 = doc[1].search('table.texto tr').search('td')
    rol_rit= level_4[0].text.split(':')[1].strip
    ruc = level_4[1].text.split(':')[1].strip

    fecha = level_4[2].text.split(':')[1].strip
    caratulado = level_4[3].text.split(':')[1].strip
    tribunal =  level_4[5].text.split(':')[1].strip

    puts rol_rit,ruc, fecha,caratulado,tribunal

    #expediente corte
    doc = page.search('div#expediente').search('table.texto tr')
    level_4 = doc[1].search('table.texto tr').search('td')
    puts level_4
    corte= level_4[0].text.split(':')[1].strip
    libro = level_4[2].text.split(':')[1].strip

    rol_ing = level_4[3].text.split(':')[1].strip
    recurso = level_4[4].text.split(':')[1].strip

    puts corte,libro,rol_ing,recurso

    break

    @list << (things)
    end

    #puts @list.first



    return @list


  end

end