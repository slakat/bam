module Scrapers
  class CivilScraper
    
    def self.search_by_rut(input, user)
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

      # puts a.cookies[0]
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
        if properties[5].nil?
          things = [properties[0].strip,properties[3],'',properties[4]]
        else
          things = [properties[0].strip,properties[3],properties[4],properties[5]]
        end
        things << n.search('td.textoC a').map{|link| link['href']}.first.strip

        puts things
        b = Mechanize.new { |agent|
          agent.user_agent_alias = 'Mac Safari'
        }

        page = b.post('http://civil.poderjudicial.cl'+things.last)

        #puts page.content

        doc = page.search('table tr')
        level_2 = doc[2].search('td')
        rol= level_2[0].text.split(':')[1].strip
        fecha = level_2[2].text.split(':')[1].strip #
        level_3 = doc[3].search('td')
        est_adm = level_3[0].text.split(':')[1].strip
        ubicacion= level_3[2].text.split(':')[1].strip
        level_4 = doc[4].search('td')
        est_proc = level_4[1].text.split(':')[1].strip
        level_5 = doc[5].search('td')
        tribunal = level_5[0].text.split(':')[1].strip #

        litigantes = []
        litigantes_rb = []
        page.search('#Litigantes tr.lineaGrilla1', '#Litigantes tr.lineaGrilla2').each do |l|
          begin 
            data = []
            l.search('td').each do |a|
              data << a.text.strip            
            end
            litigantes << data
            lit = Litigante.new(
              participante: Scrapers::LaboralScraper.clear_string(data[0]),
              rut: Scrapers::LaboralScraper.clear_string(data[1]),
              persona: Scrapers::LaboralScraper.clear_string(data[2]),
              nombre: Scrapers::LaboralScraper.clear_string(data[3])
              )   
            if lit.save
              litigantes_rb << lit
            end       
          rescue
          end
        end

        retiros = Array.new
        page.search('#ReceptorDIV table')[3].search('tr.lineaGrilla1','tr.lineaGrilla2').each do |r|
          
          
            data = r.search('td')
            cuaderno = data[0].text.strip
            datos_retiro = data[1].text.strip
            descripcion = data[2].text.strip
            puts cuaderno,datos_retiro,descripcion

            ret = Retiro.new(cuaderno: Scrapers::LaboralScraper.clear_string(cuaderno), datos_retiro: Scrapers::LaboralScraper.clear_string(datos_retiro), estado: Scrapers::LaboralScraper.clear_string(descripcion))
            if ret.save
              retiros << ret
            end
          
        end
        
        causa_civil = CivilCausa.new(
              rol: Scrapers::LaboralScraper.clear_string(things[0]), 
              fecha_ingreso: Scrapers::LaboralScraper.clear_string(things[1]),
              caratulado: Scrapers::LaboralScraper.clear_string(things[2]), 
              tribunal: Scrapers::LaboralScraper.clear_string(things[3]), 
              link: Scrapers::LaboralScraper.clear_string(things[4]),
              estado_procesal: Scrapers::LaboralScraper.clear_string(est_proc),
              ubicacion: Scrapers::LaboralScraper.clear_string(ubicacion),
              administrativo: Scrapers::LaboralScraper.clear_string(est_adm)
              )

        
        if causa_civil.save
          puts "Se ha agregado una causa de civil (por rut)"
          general_causa = user.general_causas.build
          causa_civil.general_causa = general_causa
          user.general_causas << general_causa        
        else
          puts "Se ha reasignado una causa civil existente (por rut)"
          causa_civil2 = CivilCausa.find_by(rol: Scrapers::LaboralScraper.clear_string(things[0]), caratulado: Scrapers::LaboralScraper.clear_string(things[2]))

          if causa_civil.ubicacion != causa_civil2.ubicacion
            #Cambio ubicacion!!!!
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_civil2.ubicacion,
                new_value: causa_civil.ubicacion,
                atributo: "Ubicación",
                identificador: causa_civil2.rol,
                tipo: "Civil",
                general_causa_id: causa_civil2.general_causa.id
              )    
            causa_civil2.ubicacion = causa_civil.ubicacion
          end
          if causa_civil.estado_procesal != causa_civil2.estado_procesal
            #cambio estado
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_civil2.estado_procesal,
                new_value: causa_civil.estado_procesal,
                atributo: "Estado Procesal",
                identificador: causa_civil2.rol,
                tipo: "Civil",
                general_causa_id: causa_civil2.general_causa.id
              )    
            causa_civil2.estado_procesal = causa_civil.estado_procesal
          end
          causa_civil = causa_civil2
          general_causa = causa_civil.general_causa
        end        

        

        

        general_causa.save
        causa_civil.save
        user.save

        retiros.each do |retiro|
          #comparar retiros
          ret = causa_civil.retiros.find_by(cuaderno: retiro.cuaderno, datos_retiro: retiro.datos_retiro)
          if ret.nil?
            causa_civil.retiros << retiro
            retiro.save          
          else
            if ret.estado != retiro.estado
              causa_civil.retiros << retiro          
              CausaChange.create(   
                fecha: Date.today,
                old_value: ret.estado,
                new_value: retiro.estado,
                atributo: "Retiros",
                identificador: causa_civil.rol,
                tipo: "Civil",
                general_causa_id: causa_civil.general_causa.id
              )    
              retiro.save
            else
              retiro.destroy
            end
          end
        end

        litigantes_rb.each do |lit|
          begin
            lit.general_causa_id = general_causa.id
            lit.save
          rescue
          end
        end

        @list << (things)
      end
      
      #list = ["C-4023-1999", "30/07/1999", "VELASCO PATRICIO/SOC.DE LUBRIC", "2\xBA Juzgado Civil de Santiago", "/CIVILPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&TIP_Cuaderno=49&CRR_IdCuaderno=3627217&ROL_Causa=4023&TIP_Causa=C&ERA_Causa=1999&CRR_IdCausa=3038972&COD_Tribunal=260&TIP_Informe=1&"] 
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

      a.get('http://civil.poderjudicial.cl/CIVILPORWEB') do |page|
        # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

        # }.submit
        a.cookie_jar
        page = a.get("http://civil.poderjudicial.cl/CIVILPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
      end

      # puts a.cookies[0]
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
      page.search('table#contentCellsAddTabla tr').each do |n|
        properties = n.search('td.textoC a/text()','td/text()').collect {|text| text.to_s}
        if properties[5].nil?
          things = [properties[0].strip,properties[3],'',properties[4]]
        else
          things = [properties[0].strip,properties[3],properties[4],properties[5]]
        end
        things << n.search('td.textoC a').map{|link| link['href']}.first.strip

        puts things
        b = Mechanize.new { |agent|
          agent.user_agent_alias = 'Mac Safari'
        }

        page = b.post('http://civil.poderjudicial.cl'+things.last)

        #puts page.content

        doc = page.search('table tr')
        level_2 = doc[2].search('td')
        rol= level_2[0].text.split(':')[1].strip
        fecha = level_2[2].text.split(':')[1].strip #
        level_3 = doc[3].search('td')
        est_adm = level_3[0].text.split(':')[1].strip
        ubicacion= level_3[2].text.split(':')[1].strip
        level_4 = doc[4].search('td')
        est_proc = level_4[1].text.split(':')[1].strip
        level_5 = doc[5].search('td')
        tribunal = level_5[0].text.split(':')[1].strip #

        litigantes = []
        litigantes_rb = []
        page.search('#Litigantes tr.lineaGrilla1', '#Litigantes tr.lineaGrilla2').each do |l|
          begin 
            data = []
            l.search('td').each do |a|
              data << a.text.strip            
            end
            litigantes << data
            lit = Litigante.new(
              participante: Scrapers::LaboralScraper.clear_string(data[0]),
              rut: Scrapers::LaboralScraper.clear_string(data[1]),
              persona: Scrapers::LaboralScraper.clear_string(data[2]),
              nombre: Scrapers::LaboralScraper.clear_string(data[3])
              )   
            if lit.save
              litigantes_rb << lit
            end       
          rescue
          end
        end

        retiros = Array.new
        page.search('#ReceptorDIV table')[3].search('tr.lineaGrilla1','tr.lineaGrilla2').each do |r|
          
          
            data = r.search('td')
            cuaderno = data[0].text.strip
            datos_retiro = data[1].text.strip
            descripcion = data[2].text.strip
            puts cuaderno,datos_retiro,descripcion

            ret = Retiro.new(cuaderno: Scrapers::LaboralScraper.clear_string(cuaderno), datos_retiro: Scrapers::LaboralScraper.clear_string(datos_retiro), estado: Scrapers::LaboralScraper.clear_string(descripcion))
            if ret.save
              retiros << ret
            end
          
        end
        
        causa_civil = CivilCausa.new(
              rol: Scrapers::LaboralScraper.clear_string(things[0]), 
              fecha_ingreso: Scrapers::LaboralScraper.clear_string(things[1]),
              caratulado: Scrapers::LaboralScraper.clear_string(things[2]), 
              tribunal: Scrapers::LaboralScraper.clear_string(things[3]), 
              link: Scrapers::LaboralScraper.clear_string(things[4]),
              estado_procesal: Scrapers::LaboralScraper.clear_string(est_proc),
              ubicacion: Scrapers::LaboralScraper.clear_string(ubicacion),
              administrativo: Scrapers::LaboralScraper.clear_string(est_adm)
              )

        
        if causa_civil.save
          puts "Se ha agregado una causa de civil (por rut)"
          general_causa = user.general_causas.build
          causa_civil.general_causa = general_causa
          user.general_causas << general_causa        
        else
          puts "Se ha reasignado una causa civil existente (por rut)"
          causa_civil2 = CivilCausa.find_by(rol: Scrapers::LaboralScraper.clear_string(things[0]), caratulado: Scrapers::LaboralScraper.clear_string(things[2]))

          if causa_civil.ubicacion != causa_civil2.ubicacion
            #Cambio ubicacion!!!!
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_civil2.ubicacion,
                new_value: causa_civil.ubicacion,
                atributo: "Ubicación",
                identificador: causa_civil2.rol,
                tipo: "Civil",
                general_causa_id: causa_civil2.general_causa.id
              )    
            causa_civil2.ubicacion = causa_civil.ubicacion
          end
          if causa_civil.estado_procesal != causa_civil2.estado_procesal
            #cambio estado
            CausaChange.create(   
                fecha: Date.today,
                old_value: causa_civil2.estado_procesal,
                new_value: causa_civil.estado_procesal,
                atributo: "Estado Procesal",
                identificador: causa_civil2.rol,
                tipo: "Civil",
                general_causa_id: causa_civil2.general_causa.id
              )    
            causa_civil2.estado_procesal = causa_civil.estado_procesal
          end
          causa_civil = causa_civil2
          general_causa = causa_civil.general_causa
        end        

        

        

        general_causa.save
        causa_civil.save
        user.save

        retiros.each do |retiro|
          #comparar retiros
          ret = causa_civil.retiros.find_by(cuaderno: retiro.cuaderno, datos_retiro: retiro.datos_retiro)
          if ret.nil?
            causa_civil.retiros << retiro
            retiro.save          
          else
            if ret.estado != retiro.estado
              causa_civil.retiros << retiro          
              CausaChange.create(   
                fecha: Date.today,
                old_value: ret.estado,
                new_value: retiro.estado,
                atributo: "Retiros",
                identificador: causa_civil.rol,
                tipo: "Civil",
                general_causa_id: causa_civil.general_causa.id
              )    
              retiro.save
            else
              retiro.destroy
            end
          end
        end

        litigantes_rb.each do |lit|
          begin
            lit.general_causa_id = general_causa.id
            lit.save
          rescue
          end
        end

        @list << (things)
      end
      
      #list = ["C-4023-1999", "30/07/1999", "VELASCO PATRICIO/SOC.DE LUBRIC", "2\xBA Juzgado Civil de Santiago", "/CIVILPORWEB/ConsultaDetalleAtPublicoAccion.do?TIP_Consulta=1&TIP_Cuaderno=49&CRR_IdCuaderno=3627217&ROL_Causa=4023&TIP_Causa=C&ERA_Causa=1999&CRR_IdCausa=3038972&COD_Tribunal=260&TIP_Informe=1&"] 
      # @list.each do |list|        
        
      # end
      return @list
    end

  end

end