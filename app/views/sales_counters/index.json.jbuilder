json.array!(@sales_counters) do |sales_counter|
  json.extract! sales_counter, :id, :nama, :nik, :email
  json.url sales_counter_url(sales_counter, format: :json)
end
