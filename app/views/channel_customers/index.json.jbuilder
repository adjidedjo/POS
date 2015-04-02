json.array!(@channel_customers) do |channel_customer|
  json.extract! channel_customer, :id, :kode_channel_customer, :channel_id, :nama, :alamat, :dari_tanggal, :sampai_tanggal
  json.url channel_customer_url(channel_customer, format: :json)
end
