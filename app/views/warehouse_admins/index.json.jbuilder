json.array!(@warehouse_admins) do |warehouse_admin|
  json.extract! warehouse_admin, :id, :nik, :nama, :email, :branch_id
  json.url warehouse_admin_url(warehouse_admin, format: :json)
end
