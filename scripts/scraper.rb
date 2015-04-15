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


=begin
browser = Mechanize.new{ |agent|
    agent.gzip_enabled = true
  }
browser.user_agent_alias = 'Windows Mozilla'
browser.keep_alive=false
browser.open_timeout=15
browser.read_timeout=15
page = browser.post('http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do', {"TIP_Consulta"=>"3",
"TIP_Lengueta"=>"tdCuatro","SeleccionL"=>"0","TIP_Causa"=> "","ROL_Causa"=>"","ERA_Causa"=>"0","RUC_Era"=>"","RUC_Tribunal"=>"4","RUC_Numero"=>"","RUC_Dv"=>"","FEC_Desde"=>"11%2F04%2F2015","FEC_Hasta"=>"11%2F04%2F2015","SEL_Trabajadores"=>"0","RUT_Consulta"=>"","RUT_DvConsulta"=>"","irAccionAtPublico"=>"Consulta","NOM_Consulta"=>"JERONIMO","APE_Paterno"=>"ALVEAR","APE_Materno"=>"","GLS_Razon"=>"","COD_Tribunal"=>"1351"},{'Host'=> 'laboral.poderjudicial.cl','User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0' , 'Accept'=> 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8', 'Accept-Language'=> 'es-CL,es;q=0.8,en-US;q=0.5,en;q=0.3'})

puts page.content

downloaded_file = page.body
File.open('scripts/new_file.txt', 'w') { |file| file.write downloaded_file }


agent = Mechanize.new
agent.get("http://laboral.poderjudicial.cl/SITLAPORWEB/AtPublicoViewAccion.do")
puts agent.page.body
form = agent.page.forms.first
form.fields.each { |f| puts f.Nom_Consulta }
form['NOM_Consulta'] = "JERONIMO"
form['APE_Paterno'] = "ALVEAR"
form['COD_Tribunal'] = "1351"
puts form['NOM_Consulta']
form.submit
#agent.page.link_with(:text => "Wish List").click
#agent.page.search(".edit_item").map(&:text).map(&:strip)
agent.page.content


uri = URI.parse("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoDAction.do")

# Shortcut
#response = Net::HTTP.post_form(uri, {"user[name]" => "testusername", "user[email]" => "testemail@yahoo.com"})

# Full control
http = Net::HTTP.new(uri.host, uri.port)

request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data({'TIP_Consulta'=>'3','TIP_Lengueta'=>'tdNombre','TIP_Causa'=>'+','COD_Libro'=>'null','COD_Corte'=>'91','ROL_Recurso'=>'','ERA_Recurso'=>'','FEC_Desde'=>'12%2F04%2F2015','FEC_Hasta'=>'12%2F04%2F2015','NOM_Consulta'=>'JERONIMO','APE_Paterno'=>'ALVEAR','APE_Materno'=>'','selConsulta'=>'0','ROL_Causa'=>'','ERA_Causa'=>'','RUC_Era'=>'','RUC_Tribunal'=>'','RUC_Numero'=>'','RUC_Dv'=>'','irAccionAtPublico'=>'Consulta'})

response = http.request(request)
puts response.body
=end

