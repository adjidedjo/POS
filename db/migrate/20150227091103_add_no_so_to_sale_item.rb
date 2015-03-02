class AddNoSoToSaleItem < ActiveRecord::Migration
  def change
    add_column :sale_items, :no_so, :string
    add_column :sale_items, :no_ppb, :string
    add_column :sale_items, :no_faktur, :string
    add_column :sale_items, :nos_sj, :string
  end
end
