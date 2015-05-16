module Scrapers

  class SupremaScraper
    
    def self.search_by_rut(input, user)
      rut = input.split('-')
      
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
        things = [properties[1].strip, properties[2],properties[3],properties[4],properties[5],properties[6].strip,properties[7]]
        things << n.search('td a').map{|link| link['href']}.first.strip     
        @list << (things)
        puts n.body
      end

      #list = ["3990-2012", " (Familia) Casaci\xF3n Fondo  ", "  22/05/2012 ", " Fallado y devuelto ", "  20/07/2012 ", " Corte Suprema ", "  \r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t\t-- \r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t", "/SITSUPPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&COD_Ubicacion=0&GLS_Causa=0&COD_Libro=6&ROL_Recurso=3990&ERA_Recurso=2012&COD_Corte=1&GLS_Caratulado=--&"] 
      #user = User.last
      
      @list.each do |list|
        causa_suprema = SupremaCausa.new numero_ingreso: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), tipo_recurso: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ingreso: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), ubicacion: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ubicacion: list[4].encode('UTF-8', :invalid => :replace, :undef => :replace), corte: list[5].encode('UTF-8', :invalid => :replace, :undef => :replace), caratulado: list[6].encode('UTF-8', :invalid => :replace, :undef => :replace) , link: list[7].encode('UTF-8', :invalid => :replace, :undef => :replace)
         
        causa_suprema.save
        general_causa = user.account.general_causas.build        
        causa_suprema.general_causa = general_causa
        general_causa.save
        causa_suprema.save
      end

      return @list

    end
    
    def self.search_by_name(a, b, c, user)
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
      puts n
      things = [properties[1].strip,properties[2],properties[3],properties[4],properties[5],properties[6],properties[7]]
      things << n.search('td a').map{|link| link['href']}.first.strip     
      @list << (things)
      end

      @list.each do |list|
        causa_suprema = SupremaCausa.new numero_ingreso: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), tipo_recurso: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ingreso: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), ubicacion: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace), fecha_ubicacion: list[4].encode('UTF-8', :invalid => :replace, :undef => :replace), corte: list[5].encode('UTF-8', :invalid => :replace, :undef => :replace), caratulado: list[6].encode('UTF-8', :invalid => :replace, :undef => :replace) , link: list[7].encode('UTF-8', :invalid => :replace, :undef => :replace)
         
        causa_suprema.save
        general_causa = user.account.general_causas.build        
        causa_suprema.general_causa = general_causa
        general_causa.save
        causa_suprema.save
      end


      return @list


    end

  end

end