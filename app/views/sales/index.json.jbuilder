json.array!(@sales) do |sale|
  json.extract! sale, :id, :asal_so, :salesman_id, :nota_bene, :keterangan_customer, :venue_id, :spg, :customer, :phone_number, :hp1, :hp2, :alamat_kirim, :so_manual
  json.url sale_url(sale, format: :json)
end
