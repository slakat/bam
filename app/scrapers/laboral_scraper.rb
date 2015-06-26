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
    properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
    things = [properties[0].strip,properties[3],properties[4],properties[5],properties[6]]
    things << n.search('td a').map{|link| link['href']}.first.strip
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
  
  def self.search_by_name(a,b,c)
    name, last_name, second_last_name = ""
    name = a.upcase unless a.nil? 
    last_name = b.upcase unless b.nil?
    second_last_name = c.upcase unless c.nil?
     a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://laboral.poderjudicial.cl/SITLAPORWEB/jsp/LoginPortal/LoginPortal.jsp') do |page|
      search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      }.submit

      a.cookie_jar

      page = a.get("http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")



    end

    puts a.cookies[0]
    page = a.post('http://laboral.poderjudicial.cl//SITLAPORWEB/AtPublicoDAction.do', {"TIP_Consulta"=>"3","TIP_Lengueta"=>"tdCuatro","SeleccionL"=>"0","TIP_Causa"=>"","ROL_Causa"=>"","ERA_Causa"=>"0","RUC_Era"=>"","RUC_Tribunal"=>"4","RUC_Numero"=>"","RUC_Dv"=>"","FEC_Desde"=>"11%2F04%2F2015","FEC_Hasta"=>"11%2F04%2F2015","SEL_Trabajadores"=>"0","RUT_Consulta"=>"","RUT_DvConsulta"=>"","irAccionAtPublico"=>"Consulta","NOM_Consulta"=>name,"APE_Paterno"=>last_name,"APE_Materno"=>second_last_name,"GLS_Razon"=>"","COD_Tribunal"=>"0"},{'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=11:40; NUM_SalaUsuario=0; #{a.cookies[0]};"})

  @list=[]
    #puts page.search("table#filaSel tr").inner_text
    page.search('table#filaSel tr').each do |n|
      properties = n.search('td a/text()','td/text()').collect {|text| text.to_s}
      things = [properties[0].strip,properties[3],properties[4],properties[5],properties[6]]
      things << n.search('td a').map{|link| link['href']}.first.strip


      b = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }

      page = b.post('http://laboral.poderjudicial.cl'+things.last)

      #puts page.content

      doc = page.search('tr.textoPortal')
      level_2 = doc[0].search('td')
      rit= level_2[0].text.split(':')[1].strip
      fecha = level_2[2].text.split(':')[1].strip

      level_3 = doc[1].search('td')
      ruc = level_3[0].text.split(':')[1].strip

      level_4 = doc[2].search('td')
      est_adm = level_4[0].text.split(':')[1].strip
      est_proc = level_4[2].text.split(':')[1].strip


      level_5 = doc[3].search('td')
      tribunal = level_5[0].text.split(':')[1].strip

      puts rit, fecha , ruc, est_adm,est_proc,tribunal

      litigantes = []

      page.search('#Litigantes tr.filadostabla', '#Litigantes tr.filaunodtabla').each do |l|
          data = []
          l.search('td').each_with_index do |a,index|
            next if index<2

            data << a.text.strip
          end
          litigantes << data
        end
      puts litigantes




      @list << (things)
    end

    puts @list.first[0]
    puts @list.first[1]
    puts @list.first[2]
    puts @list.first[3]
    puts @list.first[4]
    puts @list.first[5]


=begin
    @list.each do |l|
      n = LaboralCausa.new(  :rit => l[0],
                        :ruc => l[1],
                        :fecha => l[2],
                        :caratulado => l[3],
                        :tribunal => l[4])
      n.save
      g = GeneralCausa.new( :causa_id => n.id,
                            :causa_type => n.class.name)
      g.save
    end
=end

    return @list


  end

end