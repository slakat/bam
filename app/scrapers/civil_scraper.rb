class CivilScraper
  
  def self.search_by_rut(input)
    rut = input.split('-')
  
   a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
  }

  a.get('http://civil.poderjudicial.cl/CIVILPORWEB') do |page|
    # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

    # }.submit

    a.cookie_jar

    page = a.get("http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
  end

  puts a.cookies[0]
  page = a.post('http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do', {
  "TIP_Consulta"=>"2",
  "TIP_Lengueta"=>"tdTres",
  "SeleccionL"=>"0",
  "TIP_Causa"=>"",
  "ROL_Causa"=>"",
  "ERA_Causa"=>"",
  "RUC_Era"=>"",
  "RUC_Tribunal"=>"3",
  "RUC_Numero"=>"",
  "RUC_Dv"=>"",
  "FEC_Desde"=>"15/04/2015",
  "FEC_Hasta"=>"15/04/2015",
  "SEL_Litigantes"=>"0",
  "RUT_Consulta"=>rut[0],
  "RUT_DvConsulta"=>rut[1],
  "NOM_Consulta"=>"",
  "APE_Paterno"=>"",
  "APE_Materno"=>"",
  "COD_Tribunal"=>"0",
  "irAccionAtPublico"=>"Consulta",
    },{'Cookie'=>"FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Pe\xf1a Perez; HORA_LOGIN=05:05; #{a.cookies[0]};"})


  @list=[]
  #puts page.search("table#filaSel tr").inner_text
  page.search('table#contentCellsAddTabla tr').each do |n|
    properties = n.search('td.textoC a/text()','td/text()').collect {|text| text.to_s}
    things = [properties[0].strip,properties[3],properties[4],properties[5]]
    things << n.search('td.textoC a').map{|link| link['href']}.first.strip
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

    a.get('http://civil.poderjudicial.cl/CIVILPORWEB') do |page|
      # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      # }.submit

      a.cookie_jar

      page = a.get("http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
    end

    puts a.cookies[0]
    page = a.post('http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoDAction.do', {
    "TIP_Consulta"=>"3",
    "TIP_Lengueta"=>"tdCuatro",
    "SeleccionL"=>"0",
    "TIP_Causa"=>"",
    "ROL_Causa"=>"",
    "ERA_Causa"=>"",
    "RUC_Era"=>"",
    "RUC_Tribunal"=>"3",
    "RUC_Numero"=>"",
    "RUC_Dv"=>"",
    "FEC_Desde"=>"26/04/2015",
    "FEC_Hasta"=>"26/04/2015",
    "SEL_Litigantes"=>"0",
    "RUT_Consulta"=>"",
    "RUT_DvConsulta"=>"",
    "NOM_Consulta"=>name,
    "APE_Paterno"=>last_name,
    "APE_Materno"=>second_last_name,
    "COD_Tribunal"=>"0",
    "irAccionAtPublico"=>"Consulta",
      },{'Cookie'=>"FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Pe\xf1a Perez; HORA_LOGIN=05:05; #{a.cookies[0]};"})


  @list=[]
    #puts page.search("table#filaSel tr").inner_text
    page.search('table#contentCellsAddTabla tr').each do |n|
      properties = n.search('td.textoC a/text()','td/text()').collect {|text| text.to_s}
      if properties[5].nil?
        things = [properties[0].strip,properties[3],'',properties[4]]
      else
        things = [properties[0].strip,properties[3],properties[4],properties[5]]
      end
      things << n.search('td.textoC a').map{|link| link['href']}.first.strip


      b = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }

      page = b.post('http://civil.poderjudicial.cl'+things.last)

      #puts page.content

      doc = page.search('table tr')
      level_2 = doc[2].search('td')
      rol= level_2[0].text.split(':')[1].strip
      fecha = level_2[2].text.split(':')[1].strip
      level_3 = doc[3].search('td')
      est_adm = level_3[0].text.split(':')[1].strip
      ubicacion= level_3[2].text.split(':')[1].strip
      level_4 = doc[4].search('td')
      est_proc = level_4[1].text.split(':')[1].strip
      level_5 = doc[5].search('td')
      tribunal = level_5[0].text.split(':')[1].strip

      litigantes = []

      page.search('#Litigantes tr.lineaGrilla1', '#Litigantes tr.lineaGrilla2').each do |l|
        data = []
        l.search('td').each do |a|
          data << a.text.strip
        end
        litigantes << data
      end

      page.search('#ReceptorDIV table')[3].search('tr','tr.lineaGrilla1','tr.lineaGrilla2').each do |r|
        data = r.search('td')
        cuaderno = data[0].text.strip
        datos_retiro = data[1].text.strip
        descripcion = data[2].text.strip
        puts cuaderno,datos_retiro,descripcion

      end

      break


      @list << (things)
    end

    puts @list.first



    return @list


  end

end