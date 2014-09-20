['all', Rails.env].each do |seed|
  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    puts "*** Loading #{seed} seed data"
    require_relative seed_file
  end
end
#TODO: Falta idear una forma de manejar scripts que se suben con el sistema en producción y que deben ser leidos por los seed también. Además debe permitir dividir la carga cuando el script del ambiente se extienda demasiado.