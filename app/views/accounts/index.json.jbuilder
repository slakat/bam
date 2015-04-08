json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :lastname, :rut
  json.url account_url(account, format: :json)
end
