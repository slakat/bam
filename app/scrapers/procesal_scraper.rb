#10696737-7
class ProcesalScraper
  
  def self.search_by_rut(input)
    rut = input.split('-')
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf') do |page|
      # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      # }.submit
      a.cookie_jar
      #page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
    end

    @list=[]
    tribunales = []
    a.page.search('select[name="formConsultaCausas:idSelectedCodeTribunalNom"]').children.each do |n|
      tribunales << n.attr("value")
    end
    tribunales.reject! { |c| c == "-1" || c.nil? }

    ## probar distintos años. Ver si hay algun tribunal que sean todos
    ## almacenar los resultados en la lista
    tribunales.each do |tribunal|
      page = a.post('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf', {
      #{}"formConsultaCausas:idTabs"=>"idTabRut",
      "formConsultaCausas:idTabs"=>"idTabNombre",
      "formConsultaCausas:idValueRadio"=>"1",      
      #{}"formConsultaCausas:idFormRut"=>"10696737",
      #{}"formConsultaCausas:idFormRutDv"=>"7",
      "formConsultaCausas:idFormRolInterno"=>"",
      "formConsultaCausas:idFormRolInternoEra"=>"",
      "formConsultaCausas:idSelectedCodeTipCauRef"=>"",
      "formConsultaCausas:idFormRolUnico"=>"",
      "formConsultaCausas:idFormRolUnicoDv"=>"",
      "formConsultaCausas:idSelectedCodeTribunal"=>"",
      "formConsultaCausas:tblListaParticipantes:s"=>"-1",
      "formConsultaCausas:tblListaRelaciones:s"=>"-1",
      "formConsultaCausas:tblListaTramites:s"=>"-1",
      "formConsultaCausas:tblListaNotificaciones:s"=>"-1",
      "formConsultaCausas:idFormNombres"=>"",
      "formConsultaCausas:idFormApPater"=>"",
      "formConsultaCausas:idFormApMater"=>"",
      "formConsultaCausas:idFormFecEra"=>"0",
      "formConsultaCausas:idSelectedCodeTribunalRut"=>tribunal,
      #{}"formConsultaCausas:idSelectedCodeTribunalNom"=>"1245",
      "formConsultaCausas:buscar2.x"=>"50",
      "formConsultaCausas:buscar2.y"=>"9",
      "formConsultaCausas:tblListaConsultaNombres:s"=>"-1",
      "formConsultaCausas:tblListaParticipantesNom:s"=>"-1",
      "formConsultaCausas:tblListaRelacionesNom:"=>"-1",
      "formConsultaCausas:tblListaTramitesNom:s"=>"-1",
      "formConsultaCausas:tblListaNotificacionesNom:s"=>"-1",
      "formConsultaCausas:waitCargaSentOpenedState"=>"",
      "formConsultaCausas"=>"formConsultaCausas",
      "autoScroll"=>"",
      "javax.faces.ViewState"=>a.page.forms[0]['javax.faces.ViewState']})

      @list=[]
      page.search("tr.extdt-firstrow.rich-extdt-firstrow").each do |n|
        #puts 1
        properties = []
        n.search('.texto').each do |content|
              properties << content.content
        end
        #puts properties            
        things = [properties[0].strip,properties[1], "#{properties[2]}-#{properties[3]}", properties[4], properties[5]]
        #puts things
        @list << (things)
      end
    end

        
    return @list
  end
  
  def self.search_by_name(a,b,c)
    name = a.upcase  
    last_name = b.upcase
    second_last_name = c.upcase
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf') do |page|
      # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

      # }.submit
      a.cookie_jar
      #page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
    end

    @list=[]
    tribunales = []
    a.page.search('select[name="formConsultaCausas:idSelectedCodeTribunalNom"]').children.each do |n|
      tribunales << n.attr("value")
    end
    tribunales.reject! { |c| c == "-1" || c.nil? }
    #puts tribunales
    ## probar distintos años. Ver si hay algun tribunal que sean todos
    ## almacenar los resultados en la lista
    tribunales.each do |tribunal|
      page = a.post('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf', {
      "formConsultaCausas:idTabs"=>"idTabNombre",
      "formConsultaCausas:idValueRadio"=>"1",
      "formConsultaCausas:idFormRolInterno"=>"",
      "formConsultaCausas:idFormRolInternoEra"=>"",
      "formConsultaCausas:idSelectedCodeTipCauRef"=>"",
      "formConsultaCausas:idFormRolUnico"=>"",
      "formConsultaCausas:idFormRolUnicoDv"=>"",
      "formConsultaCausas:idSelectedCodeTribunal"=>"",
      "formConsultaCausas:tblListaParticipantes:s"=>"-1",
      "formConsultaCausas:tblListaRelaciones:s"=>"-1",
      "formConsultaCausas:tblListaTramites:s"=>"-1",
      "formConsultaCausas:tblListaNotificaciones:s"=>"-1",
      "formConsultaCausas:idFormNombres"=>name,
      "formConsultaCausas:idFormApPater"=>last_name,
      "formConsultaCausas:idFormApMater"=>second_last_name,
      "formConsultaCausas:idFormFecEra"=>"0",
      "formConsultaCausas:idSelectedCodeTribunalNom"=>tribunal,
      "formConsultaCausas:buscar2.x"=>"50",
      "formConsultaCausas:buscar2.y"=>"9",
      "formConsultaCausas:tblListaConsultaNombres:s"=>"-1",
      "formConsultaCausas:tblListaParticipantesNom:s"=>"-1",
      "formConsultaCausas:tblListaRelacionesNom:"=>"-1",
      "formConsultaCausas:tblListaTramitesNom:s"=>"-1",
      "formConsultaCausas:tblListaNotificacionesNom:s"=>"-1",
      "formConsultaCausas:waitCargaSentOpenedState"=>"",
      "formConsultaCausas"=>"formConsultaCausas",
      "autoScroll"=>"",
      "javax.faces.ViewState"=>a.page.forms[0]['javax.faces.ViewState']})
      
      puts page
      
      @list=[]
      page.search("tr.extdt-firstrow.rich-extdt-firstrow").each do |n|
        #puts 1
        properties = []
        n.search('.texto').each do |content|
          properties << content.content
        end
        puts properties            
        things = [properties[0].strip,properties[1], "#{properties[2]}-#{properties[3]}", properties[4], properties[5]]
        puts things


        
        puts page.links.map(&:href)
        search_result = n.click
        puts search_result

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


        break

        @list << (things)
      end
    end
        
    return @list
  end

end