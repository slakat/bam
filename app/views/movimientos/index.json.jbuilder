json.array!(@movimientos) do |movimiento|
  json.extract! movimiento, :id, :dato1, :dato2
  json.url movimiento_url(movimiento, format: :json)
end
