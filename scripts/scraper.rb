require 'rubygems'
require 'mechanize'



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
page = a.post('http://laboral.poderjudicial.cl//SITLAPORWEB/AtPublicoDAction.do', {"TIP_Consulta"=>"3", "TIP_Lengueta"=>"tdCuatro","SeleccionL"=>"0","TIP_Causa"=> "","ROL_Causa"=>"","ERA_Causa"=>"0","RUC_Era"=>"","RUC_Tribunal"=>"4","RUC_Numero"=>"","RUC_Dv"=>"","FEC_Desde"=>"11%2F04%2F2015","FEC_Hasta"=>"11%2F04%2F2015","SEL_Trabajadores"=>"0","RUT_Consulta"=>"","RUT_DvConsulta"=>"","irAccionAtPublico"=>"Consulta","NOM_Consulta"=>"JERONIMO","APE_Paterno"=>"ALVEAR","APE_Materno"=>"","GLS_Razon"=>"","COD_Tribunal"=>"1351"},{'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=11:40; NUM_SalaUsuario=0; #{a.cookies[0]};"})



puts page.content

################################################################

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
"TIP_Consulta"=>"3",
"TIP_Lengueta"=>"tdNombre",
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
"APN_Nombre"=>"ALVEAR",
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
"COD_CorteAP_Pra"=>"0",
"GLS_Caratulado_Recurso"=>"",
"irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=1; COD_Usuario=autoconsulta; GLS_Corte=Corte Suprema; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:29; NUM_SalaUsuario=0; JSESSIONID=00003ZxmA6DnNKXIVGmzdke0TNO:-1; #{a.cookies[0]};"})

#####################################################################

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
"FEC_Desde"=>"15/04/2015",
"FEC_Hasta"=>"15/04/2015",
"NOM_Consulta"=>"",
"APE_Paterno"=>"ALVEAR",
"APE_Materno"=>"",
"selConsulta"=>"0",
"ROL_Causa"=>"",
"ERA_Causa"=>"",
"RUC_Era"=>"",
"RUC_Tribunal"=>"",
"RUC_Numero"=>"",
"RUC_Dv"=>"",
"irAccionAtPublico"=>"Consulta"}, {'Cookie'=>"CRR_IdFuncionario=0; COD_TipoCargo=0; COD_Corte=90; COD_Usuario=autoconsulta; GLS_Corte=C.A. de Santiago; COD_Ambiente=3; COD_Aplicacion=3; GLS_Usuario=; HORA_LOGIN=03:49; NUM_SalaUsuario=0; JSESSIONID=0000EI1ungPDe9VzjRy_pyp9glw:-1; #{a.cookies[0]};"})

################################################################################

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

a.get('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf') do |page|
  # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

  # }.submit
  a.cookie_jar
  #page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
end

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
"formConsultaCausas:idFormNombres"=>"",
"formConsultaCausas:idFormApPater"=>"alvear",
"formConsultaCausas:idFormApMater"=>"",
"formConsultaCausas:idFormFecEra"=>"2014",
"formConsultaCausas:idSelectedCodeTribunalNom"=>"1231",
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

page.search(".texto").each do |n|
	puts n.content
end

#################################################################################

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
"FEC_Desde"=>"15/04/2015",
"FEC_Hasta"=>"15/04/2015",
"SEL_Litigantes"=>"0",
"RUT_Consulta"=>"",
"RUT_DvConsulta"=>"",
"NOM_Consulta"=>"",
"APE_Paterno"=>"ALVEAR",
"APE_Materno"=>"",
"COD_Tribunal"=>"259",
"irAccionAtPublico"=>"Consulta",
	},{'Cookie'=>"FLG_Version=0; FLG_Turno=0; CRR_IdFuncionario=1; COD_TipoCargo=2; COD_Tribunal=1000; COD_Corte=90; COD_Usuario=autoconsulta1; GLS_Tribunal=Tribunal de Prueba; GLS_Comuna=Santiago; COD_Ambiente=3; COD_Aplicacion=2; GLS_Usuario=Juan Pe\xf1a Perez; HORA_LOGIN=05:05; #{a.cookies[0]};"})

puts page.content

page.search(".texto").each do |n|
	puts n.content
end

