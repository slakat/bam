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
      # puts page.content
      page.search('table#contentCells tr').each do |n|
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

         causa_suprema = SupremaCausa.new(
          numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]), 
          tipo_recurso: Scrapers::CorteScraper.clear_string(things[1]), 
          fecha_ingreso: Scrapers::CorteScraper.clear_string(things[2]), 
          ubicacion: Scrapers::CorteScraper.clear_string(things[3]), 
          fecha_ubicacion: Scrapers::CorteScraper.clear_string(things[4]), 
          corte: Scrapers::CorteScraper.clear_string(things[5]), 
          caratulado: Scrapers::CorteScraper.clear_string(things[6]), 
          link: Scrapers::CorteScraper.clear_string(things[7]),
          libro: Scrapers::CorteScraper.clear_string(libro),
          estado_recurso: Scrapers::CorteScraper.clear_string(est_recurso),
          estado_procesal: Scrapers::CorteScraper.clear_string(est_procesal)
        )
         

        litigantes = []
        litigantes_rb = []
        page.search('#contentCellsLitigantes tr.texto').each do |l|
          data = []
          l.search('td').each_with_index do |a,index|

            data << a.text.strip
          end
          litigantes << data
          lit = Litigante.create(
            participante: Scrapers::LaboralScraper.clear_string(data[0]),
            rut: Scrapers::LaboralScraper.clear_string(data[1]),
            persona: Scrapers::LaboralScraper.clear_string(data[2]),
            nombre: Scrapers::LaboralScraper.clear_string(data[3])
            )   
          if lit.save
            litigantes_rb << lit
          end       
        end
        puts litigantes

        #expediente primera instancia
        doc = page.search('div#expediente1').search('table.texto tr')
        level_4 = doc[1].search('table.texto tr').search('td')
        unless level_4.nil?          
          rol_rit= level_4[0].text.split(':')[1].strip
          ruc = level_4[1].text.split(':')[1].strip

          fecha2 = level_4[2].text.split(':')[1].strip
          caratulado = level_4[3].text.split(':')[1].strip
          tribunal =  level_4[5].text.split(':')[1].strip

          expediente = Expediente.create(
            rol_rit: Scrapers::CorteScraper.clear_string(rol_rit), 
            ruc: Scrapers::CorteScraper.clear_string(ruc), 
            fecha: Scrapers::CorteScraper.clear_string(fecha2), 
            caratulado: Scrapers::CorteScraper.clear_string(caratulado), 
            tribunal: Scrapers::CorteScraper.clear_string(tribunal)
            )
          puts rol_rit,ruc, fecha2,caratulado,tribunal
        end

        #expediente corte
        doc = page.search('div#expediente').search('table.texto tr')
        level_4 = doc[1].search('table.texto tr').search('td')
        unless level_4.nil?
          puts level_4
          corte= level_4[0].text.split(':')[1].strip
          libro = level_4[2].text.split(':')[1].strip

          rol_ing = level_4[3].text.split(':')[1].strip
          recurso = level_4[4].text.split(':')[1].strip

          puts corte,libro,rol_ing,recurso
          expediente_corte = ExpedienteCorte.create(
              corte: Scrapers::CorteScraper.clear_string(corte),
              libro: Scrapers::CorteScraper.clear_string(libro),
              rol_ing: Scrapers::CorteScraper.clear_string(rol_ing),
              recurso: Scrapers::CorteScraper.clear_string(recurso)
            )

        end

        if causa_suprema.save
          puts "Se ha agregado una causa de suprema (por nombre)"
          general_causa = user.general_causas.build
          causa_suprema.general_causa = general_causa
          user.general_causas << general_causa        
        else
          puts "Se ha reasignado una causa suprema existente (por nombre)"
          causa_suprema2 = SupremaCausa.find_by(numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]), tipo_recurso: Scrapers::CorteScraper.clear_string(things[1]))
          if causa_suprema.ubicacion != causa_suprema2.ubicacion
            cambios_a = CausaChange.create(   
                fecha: Date.today,
                old_value: causa_suprema2.ubicacion,
                new_value: causa_suprema.ubicacion,
                atributo: "Ubicacion",
                identificador: causa_suprema2.rol,
                tipo: "Suprema",
                general_causa_id: causa_suprema2.general_causa.id
              )    
            causa_suprema2.estado_procesal = causa_suprema.estado_procesal

            user_causa = UserCausa.where(general_causa_id: causa_suprema2.general_causa_id, account_id: user.id)    
            if !user_causa.nil? user_causa.not1 == 2               
              @parameters = {}
              @parameters[:subject] = "Cambio de Corte"
              @parameters[:identificator] = causa_corte.identificator
              @parameters[:name] = user.nombre
              @parameters[:competencia] = "Corte de Suprema"
              @parameters[:changes] = [cambios_a]
              Notifications.cambios_corte(@parameters, user.email).deliver_now
            end
          end
          if causa_suprema.estado_procesal != causa_suprema2.estado_procesal
            #cambio estado
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_suprema2.estado_procesal,
                new_value: causa_suprema.estado_procesal,
                atributo: "Estado Procesal",
                identificador: causa_suprema2.rol,
                tipo: "Suprema",
                general_causa_id: causa_suprema2.general_causa.id
              )    
            causa_suprema2.estado_procesal = causa_suprema.estado_procesal

            user_causa = UserCausa.where(general_causa_id: causa_suprema2.general_causa_id, account_id: user.id)    
            if !user_causa.nil? user_causa.not1 == 2               
              @parameters = {}
              @parameters[:subject] = "Cambio de Corte"
              @parameters[:identificator] = causa_corte.identificator
              @parameters[:name] = user.nombre
              @parameters[:competencia] = "Corte de Suprema"
              @parameters[:changes] = [cambios_a]
              Notifications.cambios_corte(@parameters, user.email).deliver_now
            end
          end
          causa_suprema = causa_suprema2
          general_causa = causa_suprema.general_causa
        end 
        causa_suprema.expediente = expediente
        expediente.save

        causa_suprema.expediente_corte = expediente_corte
        expediente_corte.save

        

        general_causa.save
        causa_suprema.save
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

      # list = ["3990-2012", " (Familia) Casaci\xF3n Fondo  ", "  22/05/2012 ", " Fallado y devuelto ", "  20/07/2012 ", " Corte Suprema ", "  \r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t\t-- \r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t", "/SITSUPPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&COD_Ubicacion=0&GLS_Causa=0&COD_Libro=6&ROL_Recurso=3990&ERA_Recurso=2012&COD_Corte=1&GLS_Caratulado=--&"] 
      # user = User.last
      
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
      page.search('table#contentCells tr').each do |n|
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

         causa_suprema = SupremaCausa.new(
          numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]), 
          tipo_recurso: Scrapers::CorteScraper.clear_string(things[1]), 
          fecha_ingreso: Scrapers::CorteScraper.clear_string(things[2]), 
          ubicacion: Scrapers::CorteScraper.clear_string(things[3]), 
          fecha_ubicacion: Scrapers::CorteScraper.clear_string(things[4]), 
          corte: Scrapers::CorteScraper.clear_string(things[5]), 
          caratulado: Scrapers::CorteScraper.clear_string(things[6]), 
          link: Scrapers::CorteScraper.clear_string(things[7]),
          libro: Scrapers::CorteScraper.clear_string(libro),
          estado_recurso: Scrapers::CorteScraper.clear_string(est_recurso),
          estado_procesal: Scrapers::CorteScraper.clear_string(est_procesal)
        )
         

        litigantes = []
        litigantes_rb = []
        page.search('#contentCellsLitigantes tr.texto').each do |l|
          data = []
          l.search('td').each_with_index do |a,index|

            data << a.text.strip
          end
          litigantes << data
          lit = Litigante.create(
            participante: Scrapers::LaboralScraper.clear_string(data[0]),
            rut: Scrapers::LaboralScraper.clear_string(data[1]),
            persona: Scrapers::LaboralScraper.clear_string(data[2]),
            nombre: Scrapers::LaboralScraper.clear_string(data[3])
            )   
          if lit.save
            litigantes_rb << lit
          end       
        end
        puts litigantes

        #expediente primera instancia
        doc = page.search('div#expediente1').search('table.texto tr')
        level_4 = doc[1].search('table.texto tr').search('td')
        unless level_4.nil?          
          rol_rit= level_4[0].text.split(':')[1].strip
          ruc = level_4[1].text.split(':')[1].strip

          fecha2 = level_4[2].text.split(':')[1].strip
          caratulado = level_4[3].text.split(':')[1].strip
          tribunal =  level_4[5].text.split(':')[1].strip

          expediente = Expediente.create(
            rol_rit: Scrapers::CorteScraper.clear_string(rol_rit), 
            ruc: Scrapers::CorteScraper.clear_string(ruc), 
            fecha: Scrapers::CorteScraper.clear_string(fecha2), 
            caratulado: Scrapers::CorteScraper.clear_string(caratulado), 
            tribunal: Scrapers::CorteScraper.clear_string(tribunal)
            )
          puts rol_rit,ruc, fecha2,caratulado,tribunal
        end

        #expediente corte
        doc = page.search('div#expediente').search('table.texto tr')
        level_4 = doc[1].search('table.texto tr').search('td')
        unless level_4.nil?
          puts level_4
          corte= level_4[0].text.split(':')[1].strip
          libro = level_4[2].text.split(':')[1].strip

          rol_ing = level_4[3].text.split(':')[1].strip
          recurso = level_4[4].text.split(':')[1].strip

          puts corte,libro,rol_ing,recurso
          expediente_corte = ExpedienteCorte.create(
              corte: Scrapers::CorteScraper.clear_string(corte),
              libro: Scrapers::CorteScraper.clear_string(libro),
              rol_ing: Scrapers::CorteScraper.clear_string(rol_ing),
              recurso: Scrapers::CorteScraper.clear_string(recurso)
            )

        end

        if causa_suprema.save
          puts "Se ha agregado una causa de suprema (por nombre)"
          general_causa = user.general_causas.build
          causa_suprema.general_causa = general_causa
          user.general_causas << general_causa        
        else
          puts "Se ha reasignado una causa suprema existente (por nombre)"
          causa_suprema2 = SupremaCausa.find_by(numero_ingreso: Scrapers::CorteScraper.clear_string(things[0]), tipo_recurso: Scrapers::CorteScraper.clear_string(things[1]))
          if causa_suprema.ubicacion != causa_suprema2.ubicacion
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_suprema2.ubicacion,
                new_value: causa_suprema.ubicacion,
                atributo: "Ubicacion",
                identificador: causa_suprema2.rol,
                tipo: "Suprema",
                general_causa_id: causa_suprema2.general_causa.id
              )    
            causa_suprema2.estado_procesal = causa_suprema.estado_procesal

            user_causa = UserCausa.where(general_causa_id: causa_suprema2.general_causa_id, account_id: user.id)    
            if !user_causa.nil? user_causa.not1 == 2               
              @parameters = {}
              @parameters[:subject] = "Cambio de Corte"
              @parameters[:identificator] = causa_corte.identificator
              @parameters[:name] = user.nombre
              @parameters[:competencia] = "Corte de Suprema"
              @parameters[:changes] = [cambios_a]
              Notifications.cambios_corte(@parameters, user.email).deliver_now
            end
          end
          if causa_suprema.estado_procesal != causa_suprema2.estado_procesal
            #cambio estado
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_suprema2.estado_procesal,
                new_value: causa_suprema.estado_procesal,
                atributo: "Estado Procesal",
                identificador: causa_suprema2.rol,
                tipo: "Suprema",
                general_causa_id: causa_suprema2.general_causa.id
              )    
            causa_suprema2.estado_procesal = causa_suprema.estado_procesal

            user_causa = UserCausa.where(general_causa_id: causa_suprema2.general_causa_id, account_id: user.id)    
            if !user_causa.nil? user_causa.not1 == 2               
              @parameters = {}
              @parameters[:subject] = "Cambio de Corte"
              @parameters[:identificator] = causa_corte.identificator
              @parameters[:name] = user.nombre
              @parameters[:competencia] = "Corte de Suprema"
              @parameters[:changes] = [cambios_a]
              Notifications.cambios_corte(@parameters, user.email).deliver_now
            end
          end
          causa_suprema = causa_suprema2
          general_causa = causa_suprema.general_causa
        end 
        causa_suprema.expediente = expediente
        expediente.save

        causa_suprema.expediente_corte = expediente_corte
        expediente_corte.save

        

        general_causa.save
        causa_suprema.save
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

      # list = ["3990-2012", " (Familia) Casaci\xF3n Fondo  ", "  22/05/2012 ", " Fallado y devuelto ", "  20/07/2012 ", " Corte Suprema ", "  \r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t\t-- \r\n\t\t\t\t\r\n\t\t\t\t\r\n\t\t\t\t", "/SITSUPPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&COD_Ubicacion=0&GLS_Causa=0&COD_Libro=6&ROL_Recurso=3990&ERA_Recurso=2012&COD_Corte=1&GLS_Caratulado=--&"] 
      # user = User.last
      
      return @list
    end

  end

end