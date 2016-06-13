json.array!(@transfer_items) do |transfer_item|
  json.extract! transfer_item, :id, :tfnmr, :brg, :nbrg, :jml, :ash, :tsh
  json.url transfer_item_url(transfer_item, format: :json)
end
