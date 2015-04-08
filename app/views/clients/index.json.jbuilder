json.array!(@clients) do |client|
  json.extract! client, :id, :name, :lastname, :rut
  json.url client_url(client, format: :json)
end
