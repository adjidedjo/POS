json.array!(@showrooms) do |showroom|
  json.extract! showroom, :id, :name, :branch_id, :city
  json.url showroom_url(showroom, format: :json)
end
