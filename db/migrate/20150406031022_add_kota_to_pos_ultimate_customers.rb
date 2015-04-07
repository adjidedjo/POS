class AddKotaToPosUltimateCustomers < ActiveRecord::Migration
  def change
    add_column :pos_ultimate_customers, :kota, :string
  end
end
