class LaboralScraper
  
  def self.search_by_rut(input)
    rut = input.split('-')
  
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari'}

    a.get('http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp') do |page|
    search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

    }.submit

    a.cookie_jar

    page = a.get("http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")

    end

    page = a.post('http://laboral.poderjudicial.cl//SITLAPORWEB/AtPublicoDAction.do', {"TIP_Consulta"=>"2", "TIP_Lengueta"=>"tdTres","SeleccionL"=>"0","TIP_Causa"=> "","ROL_Causa"=>"","ERA_Causa"=>"0","RUC_Era"=>"","RUC_Tribunal"=>"4","RUC_Numero"=>"","RUC_Dv"=>"","FEC_Desde"=>"11%2F04%2F2015","FEC_Hasta"=>"11%2F04%2F2015","SEL_Trabajadores"=>"0","RUT_Consulta"=>rut[0],"RUT_DvConsulta"=>rut[1],"irAccionAtPublico"=>"Consulta","NOM_Consulta"=>"","APE_Paterno"=>"","APE_Materno"=>"","GLS_Razon"=>"","COD_Tribunal"=>"0"},{'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=11:40; NUM_SalaUsuario=0; #{a.cookies[0]};"})

  @list=[]
  #puts page.search("table#filaSel tr").inner_text
  page.search('table#filaSel tr').each do |n|
    properties = n.search('td/text()').collect {|text| text.to_s}
    @list << (properties)
  end

  puts @list.first[2]
  puts @list.first[3]
  puts @list.first[4]
  puts @list.first[5]

  return @list

  end


end