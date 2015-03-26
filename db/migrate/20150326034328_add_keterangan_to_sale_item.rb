class AddKeteranganToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :keterangan, :string
  end
end
