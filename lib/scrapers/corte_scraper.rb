module Scrapers

  class CorteScraper
    
    def self.clear_string(string)
      string.encode('UTF-8', :invalid => :replace, :undef => :replace).gsub("\t", "").gsub("\r", "").gsub("\n","").gsub(/\s+/, " ").strip
    end


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
        litigantes_rb = []
        page.search('#divLitigantes tr.textoPortal').each do |l|
          data = []
          l.search('td').each_with_index do |a,index|

            data << a.text.strip
          end
          litigantes << data
          lit = Litigante.create(
            participante: data[0],
            rut: data[1],
            persona: data[2],
            nombre: data[3]
            )          
          if lit.save
            litigantes_rb << lit
          end       
        end
        puts litigantes

        #expediente

        level_4 = doc[6].search('td')
        unless level_4.nil?
          rol_rit= level_4[0].text.split(':')[1].strip
          ruc = level_4[1].text.split(':')[1].strip
          fecha2 = level_4[2].text.split(':')[1].strip
          caratulado = doc[7].search('td')[0].text.split(':')[1].strip
          tribunal =  doc[9].search('td')[0].text.split(':')[1].strip

          puts rol_rit,ruc, fecha2,caratulado,tribunal
          expediente = Expediente.create rol_rit: Scrapers::CorteScraper.clear_string(rol_rit), ruc: Scrapers::CorteScraper.clear_string(ruc), fecha: Scrapers::CorteScraper.clear_string(fecha2), caratulado: Scrapers::CorteScraper.clear_string(caratulado), tribunal: Scrapers::CorteScraper.clear_string(tribunal)
        end
        
        causa_corte = CorteCausa.new(
          numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]),
          fecha_ingreso: Scrapers::CorteScraper.clear_string(things[1]), 
          ubicacion: Scrapers::CorteScraper.clear_string(things[2]), 
          fecha_ubicacion: Scrapers::CorteScraper.clear_string(things[3]),
          libro: Scrapers::CorteScraper.clear_string(libro),
          estado_administrativo: Scrapers::CorteScraper.clear_string(est_recurso),
          #fecha, 
          #ubicacion,
          estado_procesal: Scrapers::CorteScraper.clear_string(est_procesal), 
          corte: Scrapers::CorteScraper.clear_string(things[4]), 
          caratulado: Scrapers::CorteScraper.clear_string(things[5]), 
          link: Scrapers::CorteScraper.clear_string(things[6]))
         
        
        if causa_corte.save
          puts "Se ha agregado una causa de corte (por nombre)"
          general_causa = user.general_causas.build        
          causa_corte.general_causa = general_causa
          user.general_causas << general_causa
        else
          puts "Se ha reasignado una causa corte existente (por nombre)"
          causa_corte2 = CorteCausa.find_by(numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]))
          puts causa_corte2.id
          if causa_corte.ubicacion != causa_corte2.ubicacion
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_corte2.ubicacion,
                new_value: causa_corte.ubicacion,
                atributo: "Ubicacion",
                identificador: causa_corte2.rol,
                tipo: "Corte",
                general_causa_id: causa_corte2.general_causa.id
              )    
            causa_corte2.estado_procesal = causa_corte.estado_procesal
          end
          if causa_corte.estado_procesal != causa_corte2.estado_procesal
            #cambio estado
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_corte2.estado_procesal,
                new_value: causa_corte.estado_procesal,
                atributo: "Estado Procesal",
                identificador: causa_corte2.rol,
                tipo: "Corte",
                general_causa_id: causa_corte2.general_causa.id
              )    
            causa_corte2.estado_procesal = causa_corte.estado_procesal
          end
          causa_corte = causa_corte2
          general_causa = causa_corte.general_causa          
        end        
        causa_corte.expediente = expediente
        expediente.save

        ######################################################
        # aca hay que buscar la causa anterior y vincularla!!
        ######################################################

        
        general_causa.save
        causa_corte.save
        user.save        
        litigantes_rb.each do |lit|
          begin
            lit.general_causa_id = general_causa.id
            lit.save
          rescue
          end
        end

        @list << (things)
      end

      # puts @list.first

      # list = ["Familia-4846-2007", "  24/12/2007 ", " Primera Instancia ", "  28/03/2008 ", " C.A. de Santiago ", "MU\xD1OZ / SEPULVEDA", "/SITCORTEPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&COD_Libro=11&ROL_Recurso=4846&ERA_Recurso=2007&COD_Corte=90&"]
      # user = User.last
      # @list.each do |list|

      # end
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
          end
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
        litigantes_rb = []
        page.search('#divLitigantes tr.textoPortal').each do |l|
          data = []
          l.search('td').each_with_index do |a,index|

            data << a.text.strip
          end
          litigantes << data
          lit = Litigante.create(
            participante: data[0],
            rut: data[1],
            persona: data[2],
            nombre: data[3]
            )          
          if lit.save
            litigantes_rb << lit
          end       
        end
        puts litigantes

        #expediente

        level_4 = doc[6].search('td')
        unless level_4.nil?
          rol_rit= level_4[0].text.split(':')[1].strip
          ruc = level_4[1].text.split(':')[1].strip
          fecha2 = level_4[2].text.split(':')[1].strip
          caratulado = doc[7].search('td')[0].text.split(':')[1].strip
          tribunal =  doc[9].search('td')[0].text.split(':')[1].strip

          puts rol_rit,ruc, fecha2,caratulado,tribunal
          expediente = Expediente.create rol_rit: Scrapers::CorteScraper.clear_string(rol_rit), ruc: Scrapers::CorteScraper.clear_string(ruc), fecha: Scrapers::CorteScraper.clear_string(fecha2), caratulado: Scrapers::CorteScraper.clear_string(caratulado), tribunal: Scrapers::CorteScraper.clear_string(tribunal)
        end
        
        causa_corte = CorteCausa.new(
          numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]),
          fecha_ingreso: Scrapers::CorteScraper.clear_string(things[1]), 
          ubicacion: Scrapers::CorteScraper.clear_string(things[2]), 
          fecha_ubicacion: Scrapers::CorteScraper.clear_string(things[3]),
          libro: Scrapers::CorteScraper.clear_string(libro),
          estado_administrativo: Scrapers::CorteScraper.clear_string(est_recurso),
          #fecha, 
          #ubicacion,
          estado_procesal: Scrapers::CorteScraper.clear_string(est_procesal), 
          corte: Scrapers::CorteScraper.clear_string(things[4]), 
          caratulado: Scrapers::CorteScraper.clear_string(things[5]), 
          link: Scrapers::CorteScraper.clear_string(things[6]))
         
        
        if causa_corte.save
          puts "Se ha agregado una causa de corte (por nombre)"
          general_causa = user.general_causas.build        
          causa_corte.general_causa = general_causa
          user.general_causas << general_causa
        else
          puts "Se ha reasignado una causa corte existente (por nombre)"
          causa_corte2 = CorteCausa.find_by(numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]))
          puts causa_corte2.id
          if causa_corte.ubicacion != causa_corte2.ubicacion
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_corte2.ubicacion,
                new_value: causa_corte.ubicacion,
                atributo: "Ubicacion",
                identificador: causa_corte2.rol,
                tipo: "Corte",
                general_causa_id: causa_corte2.general_causa.id
              )    
            causa_corte2.estado_procesal = causa_corte.estado_procesal
          end
          if causa_corte.estado_procesal != causa_corte2.estado_procesal
            #cambio estado
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_corte2.estado_procesal,
                new_value: causa_corte.estado_procesal,
                atributo: "Estado Procesal",
                identificador: causa_corte2.rol,
                tipo: "Corte",
                general_causa_id: causa_corte2.general_causa.id
              )    
            causa_corte2.estado_procesal = causa_corte.estado_procesal
          end
          causa_corte = causa_corte2          
          general_causa = causa_corte.general_causa          
        end        
        causa_corte.expediente = expediente
        expediente.save

        ######################################################
        # aca hay que buscar la causa anterior y vincularla!!
        ######################################################

        
        general_causa.save
        causa_corte.save
        user.save        
        litigantes_rb.each do |lit|
          begin
            lit.general_causa_id = general_causa.id
            lit.save
          rescue
          end
        end

        @list << (things)
      end

      # puts @list.first

      # list = ["Familia-4846-2007", "  24/12/2007 ", " Primera Instancia ", "  28/03/2008 ", " C.A. de Santiago ", "MU\xD1OZ / SEPULVEDA", "/SITCORTEPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&COD_Libro=11&ROL_Recurso=4846&ERA_Recurso=2007&COD_Corte=90&"]
      # user = User.last
      # @list.each do |list|

      # end
      return @list

    end

  end

end