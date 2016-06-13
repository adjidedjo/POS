json.array!(@adjusments) do |adjusment|
  json.extract! adjusment, :id, :channel_customer_id, :kode_barang, :jumlah, :alasan
  json.url adjusment_url(adjusment, format: :json)
end
