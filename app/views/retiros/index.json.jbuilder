json.array!(@retiros) do |retiro|
  json.extract! retiro, :id, :cuaderno, :data_retiro, :status
  json.url retiro_url(retiro, format: :json)
end
