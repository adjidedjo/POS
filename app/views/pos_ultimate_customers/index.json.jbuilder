json.array!(@pos_ultimate_customers) do |pos_ultimate_customer|
  json.extract! pos_ultimate_customer, :id, :nama, :alamat, :email, :no_telepon, :handphone, :handphone1, :kode_customer
  json.url pos_ultimate_customer_url(pos_ultimate_customer, format: :json)
end
