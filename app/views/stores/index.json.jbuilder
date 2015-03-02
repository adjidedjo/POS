json.array!(@stores) do |store|
  json.extract! store, :id, :channel_id, :nama, :kota, :from_period, :to_period
  json.url store_url(store, format: :json)
end
