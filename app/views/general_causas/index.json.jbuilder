json.array!(@causas) do |causa|
  json.extract! causa, :id, :rol, :date, :caratulado, :tribunal
  json.url causa_url(causa, format: :json)
end
