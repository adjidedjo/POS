class AddKotaToSale < ActiveRecord::Migration
  def change
    add_column :sales, :kota, :string
  end
end
