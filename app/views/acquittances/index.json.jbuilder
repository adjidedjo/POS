json.array!(@acquittances) do |acquittance|
  json.extract! acquittance, :id, :sale_id, :no_reference, :method_of_payment
  json.url acquittance_url(acquittance, format: :json)
end
