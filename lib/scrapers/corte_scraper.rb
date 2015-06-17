module Scrapers

  class CorteScraper
    
    def self.search_by_rut(input, user)
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
      # puts @list.first

      # list = ["Familia-4846-2007", "  24/12/2007 ", " Primera Instancia ", "  28/03/2008 ", " C.A. de Santiago ", "MU\xD1OZ / SEPULVEDA", "/SITCORTEPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&COD_Libro=11&ROL_Recurso=4846&ERA_Recurso=2007&COD_Corte=90&"]
      # user = User.last
      @list.each do |list|
        causa_corte = CorteCausa.new numero_ingreso: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ingreso: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace), ubicacion: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ubicacion: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace), corte: list[4].encode('UTF-8', :invalid => :replace, :undef => :replace), caratulado: list[5].encode('UTF-8', :invalid => :replace, :undef => :replace), link: list[6].encode('UTF-8', :invalid => :replace, :undef => :replace)
         
        # causa_corte.save
        # general_causa = user.general_causas.build        
        # causa_corte.general_causa = general_causa
        # general_causa.save
        # causa_corte.save
        # user.save
        # puts "Se ha agregado una causa de corte (por rut)"
        if causa_corte.save
          puts "Se ha agregado una causa de corte (por nombre)"
        else
          puts "Se ha reasignado una causa corte existente (por nombre)"
          causa_corte = CorteCausa.find_by(numero_ingreso: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ingreso: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace))
        end        
        general_causa = user.general_causas.build        
        causa_corte.general_causa = general_causa
        user.general_causas << general_causa
        general_causa.save
        causa_corte.save
        user.save        

      end
      return @list
    end
    
    def self.search_by_name(a, b, c, user)
      name, last_name, second_last_name = ""
      name = a.upcase unless a.nil? 
      last_name = b.upcase unless b.nil?
      second_last_name = c.upcase unless c.nil?
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
        @list << (things)
      end

      #puts @list.first

      @list.each do |list|
        causa_corte = CorteCausa.new numero_ingreso: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ingreso: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace), ubicacion: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ubicacion: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace), corte: list[4].encode('UTF-8', :invalid => :replace, :undef => :replace), caratulado: list[5].encode('UTF-8', :invalid => :replace, :undef => :replace), link: list[6].encode('UTF-8', :invalid => :replace, :undef => :replace)
         
        # causa_corte.save
        # general_causa = user.general_causas.build        
        # causa_corte.general_causa = general_causa
        # general_causa.save
        # causa_corte.save
        # user.save
        # puts "Se ha agregado una causa de corte (por nombre)"
        if causa_corte.save
          puts "Se ha agregado una causa de corte (por nombre)"
        else
          puts "Se ha reasignado una causa corte existente (por nombre)"
          causa_corte = CorteCausa.find_by(numero_ingreso: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ingreso: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace))
        end        
        general_causa = user.general_causas.build        
        causa_corte.general_causa = general_causa
        user.general_causas << general_causa
        general_causa.save
        causa_corte.save
        user.save        

      end
      return @list

    end

  end

end