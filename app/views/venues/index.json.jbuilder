json.array!(@venues) do |venue|
  json.extract! venue, :id, :venue_name, :city, :branch_id, :from_period, :to_period
  json.url venue_url(venue, format: :json)
end
